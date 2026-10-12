resource "google_compute_network" "this" {
  name                            = "${var.name_prefix}-vpc"
  project                         = var.project_id
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "private" {
  name                     = "${var.name_prefix}-app-${var.region}"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "data" {
  name                     = "${var.name_prefix}-data-${var.region}"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.data_subnet_cidr
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "management" {
  name                     = "${var.name_prefix}-management-${var.region}"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.management_subnet_cidr
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "this" {
  name    = "${var.name_prefix}-router-${var.region}"
  project = var.project_id
  region  = var.region
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  name                               = "${var.name_prefix}-nat-${var.region}"
  project                            = var.project_id
  router                             = google_compute_router.this.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "backend_ingress" {
  name      = "${var.name_prefix}-allow-lb-backend"
  project   = var.project_id
  network   = google_compute_network.this.name
  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = [var.backend_tag]

  allow {
    protocol = "tcp"
    ports    = [tostring(var.backend_port)]
  }
}

resource "google_compute_firewall" "backend_iap_ssh" {
  name      = "${var.name_prefix}-allow-iap-ssh"
  project   = var.project_id
  network   = google_compute_network.this.name
  direction = "INGRESS"
  priority  = 900

  source_ranges = ["35.235.240.0/20"]
  target_tags   = [var.backend_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "backend_egress_dns" {
  name               = "${var.name_prefix}-allow-backend-dns"
  project            = var.project_id
  network            = google_compute_network.this.name
  direction          = "EGRESS"
  priority           = 900
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = [var.backend_tag]

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }
}

resource "google_compute_firewall" "backend_egress_web" {
  name               = "${var.name_prefix}-allow-backend-web"
  project            = var.project_id
  network            = google_compute_network.this.name
  direction          = "EGRESS"
  priority           = 1000
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = [var.backend_tag]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "backend_egress_deny_other" {
  name               = "${var.name_prefix}-deny-other-backend-egress"
  project            = var.project_id
  network            = google_compute_network.this.name
  direction          = "EGRESS"
  priority           = 65534
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = [var.backend_tag]

  deny {
    protocol = "all"
  }
}
