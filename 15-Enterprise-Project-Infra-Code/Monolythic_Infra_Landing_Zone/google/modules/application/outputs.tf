output "instance_group" {
  value = google_compute_region_instance_group_manager.backend.instance_group
}

output "health_check_id" {
  value = google_compute_health_check.backend.id
}
