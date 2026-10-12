resource "google_service_account" "runtime" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-app"
  display_name = "Private application MIG runtime"
  description  = "Least-privilege identity for application instances and Cloud Ops agent writes."
}

resource "google_project_iam_member" "logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_project_iam_member" "metrics" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_compute_health_check" "backend" {
  name                = "${var.name_prefix}-http-health"
  project             = var.project_id
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = var.backend_port
    request_path = "/health"
  }
}

resource "google_compute_instance_template" "backend" {
  name_prefix  = "${var.name_prefix}-app-"
  project      = var.project_id
  machine_type = var.machine_type
  region       = var.region
  tags         = [var.backend_tag]

  disk {
    boot         = true
    auto_delete  = true
    source_image = var.boot_image
    disk_type    = "pd-balanced"
    disk_size_gb = 30
  }

  network_interface {
    subnetwork = var.subnet_id
    stack_type = "IPV4_ONLY"
  }

  service_account {
    email  = google_service_account.runtime.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    enable-oslogin              = "TRUE"
    block-project-ssh-keys      = "TRUE"
    serial-port-enable          = "FALSE"
    "google-logging-enabled"    = "true"
    "google-monitoring-enabled" = "true"
    startup-script              = <<-EOT
      #!/bin/bash
      set -euo pipefail
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx unattended-upgrades curl
      dpkg-reconfigure -f noninteractive unattended-upgrades
      cat >/etc/nginx/sites-available/default <<'NGINX'
      server {
        listen ${var.backend_port} default_server;
        listen [::]:${var.backend_port} default_server;
        server_name _;
        location = /health {
          access_log off;
          default_type text/plain;
          return 200 "healthy\n";
        }
        location / {
          default_type text/plain;
          return 200 "Private application backend\n";
        }
      }
      NGINX
      systemctl enable --now nginx
      curl -fsSLO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
      bash add-google-cloud-ops-agent-repo.sh --also-install
      rm -f add-google-cloud-ops-agent-repo.sh
    EOT
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    google_project_iam_member.logs,
    google_project_iam_member.metrics,
  ]
}

resource "google_compute_region_instance_group_manager" "backend" {
  name                      = "${var.name_prefix}-app-mig"
  project                   = var.project_id
  region                    = var.region
  distribution_policy_zones = slice(data.google_compute_zones.available.names, 0, min(2, length(data.google_compute_zones.available.names)))
  base_instance_name        = "${var.name_prefix}-app"
  target_size               = var.min_replicas
  wait_for_instances        = true

  version {
    instance_template = google_compute_instance_template.backend.id
  }

  named_port {
    name = "http"
    port = var.backend_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.backend.id
    initial_delay_sec = 300
  }

  update_policy {
    type                           = "PROACTIVE"
    minimal_action                 = "REPLACE"
    most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed                = 1
    max_unavailable_fixed          = 0
  }

  lifecycle {
    ignore_changes = [target_size]
  }
}

resource "google_compute_region_autoscaler" "backend" {
  name    = "${var.name_prefix}-app-autoscaler"
  project = var.project_id
  region  = var.region
  target  = google_compute_region_instance_group_manager.backend.id

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = 120

    cpu_utilization {
      target = 0.6
    }
  }
}
