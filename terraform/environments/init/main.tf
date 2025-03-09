# Create a service account for the project
# resource "google_service_account" "develop" {
#   account_id   = "develop"
#   display_name = "Develop"
#   project      = var.project_id
# }



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
    "roles/run.admin"
  ]
}

resource "google_project_iam_member" "develop_roles" {
  for_each = toset(local.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:develop@${var.project_id}.iam.gserviceaccount.com"
}

# Output the roles
output "roles" {
  value = local.roles
}
