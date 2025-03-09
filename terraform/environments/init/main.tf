# Data source to check if service account exists
data "google_service_account" "existing" {
  account_id = "develop"
  project    = var.project_id
}

# Create service account only if it doesn't exist
resource "google_service_account" "develop" {
  count        = data.google_service_account.existing.email == null ? 1 : 0
  account_id   = "develop"
  display_name = "Development Service Account"
  project      = var.project_id
}

# Use local variable to reference either existing or new service account
locals {
  service_account_email = try(
    data.google_service_account.existing.email,
    google_service_account.develop[0].email
  )
}


# Enable required Google Cloud APIs
resource "google_project_service" "enabled_services" {
  for_each = toset([
    # "containerregistry.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
    "servicenetworking.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-component.googleapis.com",
    "vpcaccess.googleapis.com"
  ])

  project = var.project_id
  service = each.key

  disable_dependent_services = true
  disable_on_destroy         = false
}

# IAM role bindings
locals {
  roles = [
    "roles/viewer",
    "roles/cloudbuild.builds.builder",
    "roles/compute.instanceAdmin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountUser",
    "roles/storage.admin",
    "roles/storage.objectAdmin",
    "roles/storage.objectViewer",
    "roles/artifactregistry.writer",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/vpcaccess.admin",
    "roles/cloudsql.admin",
    "roles/run.admin",
    "roles/iam.serviceAccountTokenCreator"
  ]
}

resource "google_project_iam_member" "develop_roles" {
  for_each = toset(local.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${local.service_account_email}"
}

# Create a custom logs bucket
resource "google_storage_bucket" "cloud_build_logs" {
  name                        = "cloud-build-logs-${var.project_id}"
  location                    = var.region
  uniform_bucket_level_access = true
}

# Grant Cloud Build service account access to the logs bucket
resource "google_storage_bucket_iam_member" "cloud_build_logs" {
  bucket = google_storage_bucket.cloud_build_logs.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${local.service_account_email}"
}

# Output the service account email
output "service_account_email" {
  value = local.service_account_email
}

# Output the roles
output "roles" {
  value = local.roles
}
