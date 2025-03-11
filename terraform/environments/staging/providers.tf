terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.20.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.20.0"
    }
  }

  # gcloud auth login
  # gcloud storage buckets create gs://[gcp_project_id]  --location=australia-southeast1
  backend "gcs" {
    bucket = "[gcp_project_id]"
    prefix = "terraform/state/staging"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
