# Facilitates the deployment of the Strapi service to the Google Cloud Platform (GCP) using Terraform.

# VPC Network
resource "google_compute_network" "vpc_sample_network" {
  name                    = "vpc-sample-network"
  auto_create_subnetworks = true
  mtu                     = 1460
  description             = "Sample VPC Network"
  routing_mode            = "REGIONAL"
}

# Global Address for VPC Peering
resource "google_compute_global_address" "google_managed_ip_vpc_sample_network" {
  name          = "google-managed-ip-vpc-sample-network"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.vpc_sample_network.id
  depends_on    = [google_compute_network.vpc_sample_network]
}

# VPC Peering Connection
resource "google_service_networking_connection" "vpc_peering" {
  network                 = google_compute_network.vpc_sample_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google_managed_ip_vpc_sample_network.name]
  depends_on              = [google_compute_global_address.google_managed_ip_vpc_sample_network]
}

# Cloud SQL Instance
resource "google_sql_database_instance" "strapi_postgres_v14" {
  name             = "strapi-postgres-v14"
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    tier      = "db-f1-micro"
    disk_size = 10

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc_sample_network.self_link
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled            = false
      binary_log_enabled = false
    }
  }

  deletion_protection = "false"

  depends_on = [
    google_service_networking_connection.vpc_peering
  ]
}

# Cloud SQL Database
resource "google_sql_database" "strapi_db" {
  name       = var.db_name
  instance   = google_sql_database_instance.strapi_postgres_v14.name
  depends_on = [google_sql_database_instance.strapi_postgres_v14]
}

# Cloud SQL User
resource "google_sql_user" "strapi_user" {
  name       = var.db_user
  instance   = google_sql_database_instance.strapi_postgres_v14.name
  password   = var.db_pass
  depends_on = [google_sql_database_instance.strapi_postgres_v14]
}

# Serverless VPC Access Connector
resource "google_vpc_access_connector" "sample_servless_connector" {
  name          = "sample-servless-connector"
  region        = var.region
  ip_cidr_range = "10.9.0.0/28"
  network       = google_compute_network.vpc_sample_network.id
  min_instances = 2
  max_instances = 3
  machine_type  = "e2-micro" # f1-micro is now deprecated, e2-micro is the replacement.
  depends_on    = [google_compute_network.vpc_sample_network]
}

# Service Account
resource "google_service_account" "strapi_sa" {
  account_id   = "strapi"
  display_name = "Strapi"
  description  = "Service Account for Strapi service"
}

# IAM Bindings for Service Account
resource "google_project_iam_member" "run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.strapi_sa.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.strapi_sa.email}"
}

# Cloud Run Deployment
resource "google_cloud_run_v2_service" "strapi_run" {
  name     = "strapi-image-local"
  location = var.region
  project  = var.project_id

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/strapi-docker-repo/strapi-image-local:latest"

      ports {
        container_port = 1337
        name           = "http1"
      }

      resources {
        limits = {
          memory = "2Gi"
        }
      }

      env {
        name  = "APP_KEYS"
        value = "dvVL5fy+Y7YqhhbG2G/o9w==,+4FuGgS0J+isorche9DGmA==,eyX22XP9yxhHTSfpxa+5kQ==,9yf96xUfnE8fGL7zADY7MQ=="
      }
      env {
        name  = "API_TOKEN_SALT"
        value = "fzfyMtPc3NaPHVAWjmWPfw=="
      }
      env {
        name  = "ADMIN_JWT_SECRET"
        value = "IJL8hF/vViCh8NKE7Wsv5A=="
      }
      env {
        name  = "TRANSFER_TOKEN_SALT"
        value = "b1VenQ/VZANQi8qLkM6+Kg=="
      }
      # Use Cloud SQL private IP address
      env {
        name  = "DATABASE_HOST"
        value = google_sql_database_instance.strapi_postgres_v14.private_ip_address
      }
    }

    service_account = google_service_account.strapi_sa.email

    vpc_access {
      connector = google_vpc_access_connector.sample_servless_connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [google_service_networking_connection.vpc_peering]
}

# IAM policy to allow unauthenticated access
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.strapi_run.location
  project  = google_cloud_run_v2_service.strapi_run.project
  service  = google_cloud_run_v2_service.strapi_run.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
