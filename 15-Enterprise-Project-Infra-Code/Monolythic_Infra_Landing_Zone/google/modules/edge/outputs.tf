output "ipv4_address" {
  value = google_compute_global_address.app.address
}

output "certificate_id" {
  value = google_compute_managed_ssl_certificate.app.id
}
