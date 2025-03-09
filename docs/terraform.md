# Terraform

## Prepare

- Create GCP project

- gcloud auth login
- gcloud config set project coworkout-250307
- gcloud auth application-default set-quota-project coworkout-250307

- Create service account (develop@)
- Generate credentials key json file
- Download and put in the terraform folder
- In the operation CLI winder, export the gcp key

- gcloud storage buckets create gs://coworkout-250307  --location=us-central1
- export GOOGLE_APPLICATION_CREDENTIALS=/Users/.../gcp_credentials.json

- Enable proper GCP service APIs
    gcloud services enable \
artifactregistry.googleapis.com \
cloudbuild.googleapis.com \
cloudresourcemanager.googleapis.com \
compute.googleapis.com \
iam.googleapis.com \
run.googleapis.com \
servicenetworking.googleapis.com \
sql-component.googleapis.com \
sqladmin.googleapis.com \
storage-component.googleapis.com \
vpcaccess.googleapis.com

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

- Enable IAM API - [](https://console.cloud.google.com/apis/library/iam.googleapis.com?project=coworkout-250307)
- Enable Compute Engine API - [](https://console.cloud.google.com/apis/library/compute.googleapis.com?project=coworkout-250307)
- Enable Cloud resource manager API - [](https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com?project=coworkout-250307)
- Enable Serverless VPC API = [](https://console.cloud.google.com/apis/library/vpcaccess.googleapis.com?project=coworkout-250307)
- Enable Service managing API = [](https://console.cloud.google.com/apis/library/servicenetworking.googleapis.com?project=coworkout-250307)
- Enable Cloud SQL API - [](https://console.cloud.google.com/apis/library/sqladmin.googleapis.com?project=coworkout-250307)
- Enable Cloud Run Admin API - [](https://console.cloud.google.com/apis/library/run.googleapis.com?project=coworkout-250307)
- Enable Cloud Build API - [](https://console.cloud.google.com/apis/library/cloudbuild.googleapis.com?project=coworkout-250307)

Run commands in artifact_registry.md to upload latest built strapi docker image
