# Build the Docker image using Cloud Build trigger
resource "google_cloudbuild_trigger" "build_image" {
  name = "build-strapi_server"
  trigger_template {
    repo_name   = var.repo_name # Define this variable in your variables.tf or replace with your repo name
    branch_name = "app"
  }

  filename = "cloudbuild.yaml" # Use the cloudbuild.yaml file below
  included_files = [
    "../strapi-server/Dockerfile.prod",
    "../strapi-server/package.json",
    "../strapi-server/package-lock.json",
    "../strapi-server/**/*.js",
    "../strapi-server/**/*.json",
    "../strapi-server/.env",
  ]

  substitutions = {
    _IMAGE_NAME = "australia-southeast1-docker.pkg.dev/${var.project_id}/mystrapi-repository/strapi_server:latest"
  }
}

# Deploy the image to Cloud Run
resource "google_cloud_run_service" "node_app" {
  name     = "strapi_server"
  location = "us-central1" # Must match the provider region

  template {
    spec {
      containers {
        image = "australia-southeast1-docker.pkg.dev/${var.project_id}/mystrapi-repository/strapi_server:latest" # Image built by Cloud Build
        ports {
          container_port = 1337
        }
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "5"
      }
    }
  }

  traffic {
    latest_revision = true
    percent         = 100
  }
}

# Allow unauthenticated access to Cloud Run service
resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.node_app.location
  project  = google_cloud_run_service.node_app.project
  service  = google_cloud_run_service.node_app.name

  policy_data = <<POLICY
{
  "bindings": [
    {
      "members": ["allUsers"],
      "role": "roles/run.invoker"
    }
  ]
}
POLICY
}

output "cloud_run_url" {
  value = google_cloud_run_service.node_app.status[0].url
}
