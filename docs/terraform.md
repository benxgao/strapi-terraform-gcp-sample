# Terraform

## Prepare

- Create GCP project
- Create service account (develop@)
- Assign permissions
  - Compute Instance Admin
  - Compute Network Admin
  - Service Account User
  - Storage Admin
  - Storage Object Admin
  - Storage Object Viewer

  - Artifact Registry Writer
  - Service Account Admin
  - Project IAM Admin
  - Serverless VPC Access Admin
  - Cloud SQL Admin
  - Cloud Run Admin
- Generate credentials key json file
- Download and put in the terraform folder
- In the operation CLI winder, export the gcp key
- Enable proper GCP service APIs
    gcloud services enable \
compute.googleapis.com \
cloudbuild.googleapis.com \
artifactregistry.googleapis.com \
containerregistry.googleapis.com \
sql-component.googleapis.com \
storage-component.googleapis.com \
servicenetworking.googleapis.com \
sqladmin.googleapis.com

- Run commands in artifact_registry.md to upload latest built strapi docker image

- Enable IAM API - [](https://console.cloud.google.com/apis/library/iam.googleapis.com?project=coworkout-250306)
- Enable Compute Engine API - [](https://console.cloud.google.com/apis/library/compute.googleapis.com?project=coworkout-250306)
- Enable Cloud resource manager API - [](https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com?project=coworkout-250306)
- Enable Serverless VPC API = [](https://console.cloud.google.com/apis/library/vpcaccess.googleapis.com?project=coworkout-250306)
- Enable Service managing API = [](https://console.cloud.google.com/apis/library/servicenetworking.googleapis.com?project=coworkout-250306)
- Enable Cloud SQL API - [](https://console.cloud.google.com/apis/library/sqladmin.googleapis.com?project=coworkout-250306)
- Enable Cloud Run Admin API - [](https://console.cloud.google.com/apis/library/run.googleapis.com?project=coworkout-250306)
- Enable Cloud Build API - [](https://console.cloud.google.com/apis/library/cloudbuild.googleapis.com?project=coworkout-250306)
