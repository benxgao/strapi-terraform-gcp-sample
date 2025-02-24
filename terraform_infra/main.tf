# Network
resource "google_compute_network" "mystrapi_network" {
  name                    = "mystrapi-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mystrapi_subnet" {
  name          = "mystrapi-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.mystrapi_network.id
  region        = var.region
}

# Private Service Access
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.mystrapi_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "mystrapi-sql-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  # network       = google_compute_network.mystrapi_network.self_link
  network = google_compute_network.mystrapi_network.id
}

# Firewall rules
resource "google_compute_firewall" "mystrapi_allow_http" {
  name    = "mystrapi-allow-http"
  network = google_compute_network.mystrapi_network.name
  allow {
    protocol = "tcp"
    ports    = ["1337"]
  }
  target_tags = ["mystrapi-server"]
  source_tags = ["mystrapi-network"]
}

resource "google_compute_firewall" "mystrapi_allow_adminer" {
  name    = "mystrapi-allow-adminer"
  network = google_compute_network.mystrapi_network.name
  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }
  target_tags = ["mystrapi-adminer"]
  source_tags = ["mystrapi-network"]
}

resource "google_compute_firewall" "mystrapi_allow_postgres" {
  name    = "mystrapi-allow-postgres"
  network = google_compute_network.mystrapi_network.name
  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  target_tags = ["mystrapi-db"]
  source_tags = ["mystrapi-network"]
}


# Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "mystrapi_db" {
  name             = "mystrapi-db"
  region           = var.region
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro" # Adjust tier as needed
    ip_configuration {
      ipv4_enabled    = false # Enable if public access is needed.
      private_network = google_compute_network.mystrapi_network.self_link
      # allocated_ip_range = google_compute_global_address.mystrapi_sql_private_ip.name
    }
  }
  deletion_protection = false # Adjust as needed
}

resource "google_sql_database" "mystrapi_database" {
  name     = var.database_name
  instance = google_sql_database_instance.mystrapi_db.name
}

resource "google_sql_user" "mystrapi_user" {
  name     = var.database_username
  instance = google_sql_database_instance.mystrapi_db.name
  password = var.database_password
}

# Container Registry
resource "google_artifact_registry_repository" "mystrapi_repository" {
  location      = var.region
  repository_id = "mystrapi-repository"
  format        = "DOCKER"
}

# Cloud Run deployment (for mystrapi)
resource "google_cloud_run_service" "mystrapi_service" {
  name     = "mystrapi-service"
  location = var.region
  template {
    spec {
      containers {
        image = "${google_artifact_registry_repository.mystrapi_repository.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.mystrapi_repository.repository_id}/mystrapi:latest"
        ports {
          container_port = 1337
        }
        resources {
          limits = {
            cpu    = "1"
            memory = "1Gi"
          }
        }
        env {
          name  = "DATABASE_CLIENT"
          value = "postgres"
        }
        env {
          name  = "DATABASE_HOST"
          value = google_sql_database_instance.mystrapi_db.private_ip_address
        }
        env {
          name  = "DATABASE_NAME"
          value = var.database_name
        }
        env {
          name  = "DATABASE_USERNAME"
          value = var.database_username
        }
        env {
          name  = "DATABASE_PORT"
          value = "5432"
        }
        env {
          name  = "JWT_SECRET"
          value = var.jwt_secret
        }
        env {
          name  = "ADMIN_JWT_SECRET"
          value = var.admin_jwt_secret
        }
        env {
          name  = "DATABASE_PASSWORD"
          value = var.database_password
        }
        env {
          name  = "NODE_ENV"
          value = var.node_env
        }
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
      }
    }
  }
  traffic {
    latest_revision = true
    percent         = 100
  }
  depends_on = [google_vpc_access_connector.connector]
}

# Cloud Run deployment (for adminer)
resource "google_cloud_run_service" "mystrapi_adminer_service" {
  name     = "mystrapi-adminer-service"
  location = var.region
  template {
    spec {
      containers {
        image = "adminer"
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
        env {
          name  = "ADMINER_DEFAULT_SERVER"
          value = google_sql_database_instance.mystrapi_db.private_ip_address
        }
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
      }
    }
  }
  traffic {
    latest_revision = true
    percent         = 100
  }
  depends_on = [google_vpc_access_connector.connector]
}

# VPC Access Connector (single declaration)
resource "google_vpc_access_connector" "connector" {
  name          = "mystrapi-vpc-connector"
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.mystrapi_network.self_link
  # subnet {
  #   name = google_compute_subnetwork.mystrapi_subnet.name
  # }
  min_instances = 2
  max_instances = 10
}
