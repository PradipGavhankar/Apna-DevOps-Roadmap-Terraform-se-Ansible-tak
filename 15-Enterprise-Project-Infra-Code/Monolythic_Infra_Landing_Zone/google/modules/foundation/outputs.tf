output "artifact_bucket_name" {
  value = google_storage_bucket.artifacts.name
}

output "application_secret_id" {
  value = google_secret_manager_secret.application.id
}

output "logging_bucket_id" {
  value = google_logging_project_bucket_config.operations.id
}

output "kms_key_id" {
  value = google_kms_crypto_key.data.id
}
