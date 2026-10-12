locals {
  required_apis = toset([
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "secretmanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ])
}

resource "google_project_service" "required" {
  for_each           = local.required_apis
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "network" {
  source                 = "../../modules/network"
  project_id             = var.project_id
  region                 = var.region
  name_prefix            = var.resource_prefix
  subnet_cidr            = var.subnet_cidr
  data_subnet_cidr       = var.data_subnet_cidr
  management_subnet_cidr = var.management_subnet_cidr
  backend_tag            = "${var.resource_prefix}-app"
  backend_port           = 8080

  depends_on = [google_project_service.required]
}

module "application" {
  source       = "../../modules/application"
  project_id   = var.project_id
  region       = var.region
  name_prefix  = var.resource_prefix
  subnet_id    = module.network.subnet_id
  backend_tag  = "${var.resource_prefix}-app"
  machine_type = var.machine_type
  boot_image   = var.boot_image
  min_replicas = var.min_replicas
  max_replicas = var.max_replicas
  backend_port = 8080

  depends_on = [google_project_service.required]
}

module "edge" {
  source              = "../../modules/edge"
  project_id          = var.project_id
  name_prefix         = var.resource_prefix
  certificate_domains = var.certificate_domains
  backend_group       = module.application.instance_group
  health_check_id     = module.application.health_check_id

  depends_on = [google_project_service.required]
}

module "foundation" {
  source                     = "../../modules/foundation"
  providers                  = { google-beta = google-beta }
  project_id                 = var.project_id
  region                     = var.region
  name_prefix                = var.resource_prefix
  artifact_bucket_name       = var.artifact_bucket_name
  log_retention_days         = var.log_retention_days
  artifact_retention_seconds = var.artifact_retention_seconds

  depends_on = [google_project_service.required]
}
