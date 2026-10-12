output "network_id" {
  value = google_compute_network.this.id
}

output "network_name" {
  value = google_compute_network.this.name
}

output "subnet_id" {
  value = google_compute_subnetwork.private.id
}

output "subnet_name" {
  value = google_compute_subnetwork.private.name
}

output "data_subnet_name" {
  value = google_compute_subnetwork.data.name
}

output "management_subnet_name" {
  value = google_compute_subnetwork.management.name
}
