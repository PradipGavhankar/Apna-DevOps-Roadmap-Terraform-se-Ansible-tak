resource "google_project_service_identity" "storage" {
  provider = google-beta
  project  = var.project_id
  service  = "storage.googleapis.com"
}

resource "google_project_service_identity" "secret_manager" {
  provider = google-beta
  project  = var.project_id
  service  = "secretmanager.googleapis.com"
}

resource "google_kms_key_ring" "this" {
  name     = "${var.name_prefix}-keyring"
  project  = var.project_id
  location = var.region
}

resource "google_kms_crypto_key" "data" {
  name            = "${var.name_prefix}-data-key"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "7776000s"
  purpose         = "ENCRYPT_DECRYPT"
}

resource "google_kms_crypto_key_iam_member" "storage" {
  crypto_key_id = google_kms_crypto_key.data.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.storage.email}"
}

resource "google_kms_crypto_key_iam_member" "secret_manager" {
  crypto_key_id = google_kms_crypto_key.data.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.secret_manager.email}"
}

resource "google_storage_bucket" "artifacts" {
  name                        = var.artifact_bucket_name
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  retention_policy {
    retention_period = var.artifact_retention_seconds
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.data.id
  }

  depends_on = [google_kms_crypto_key_iam_member.storage]
}

resource "google_secret_manager_secret" "application" {
  project   = var.project_id
  secret_id = "${var.name_prefix}-application-runtime"

  replication {
    user_managed {
      replicas {
        location = var.region

        customer_managed_encryption {
          kms_key_name = google_kms_crypto_key.data.id
        }
      }
    }
  }

  depends_on = [google_kms_crypto_key_iam_member.secret_manager]
}

resource "google_logging_project_bucket_config" "operations" {
  project        = var.project_id
  location       = var.region
  bucket_id      = "${var.name_prefix}-operations"
  retention_days = var.log_retention_days
  description    = "Regional operations log destination for the private application tier."
}

resource "google_logging_project_sink" "vm_logs" {
  name                   = "${var.name_prefix}-vm-log-sink"
  project                = var.project_id
  destination            = "logging.googleapis.com/${google_logging_project_bucket_config.operations.id}"
  filter                 = "resource.type=\"gce_instance\" OR resource.type=\"gce_subnetwork\""
  unique_writer_identity = true
}

resource "google_project_iam_member" "log_sink_bucket_writer" {
  project = var.project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_project_sink.vm_logs.writer_identity
}
