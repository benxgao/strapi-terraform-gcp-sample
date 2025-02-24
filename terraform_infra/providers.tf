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
  # gcloud storage buckets create gs://coworkout-20230409  --location=australia-southeast1
  backend "gcs" {
    bucket = "coworkout-20230409"
    prefix = "strapi/state/production"
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
