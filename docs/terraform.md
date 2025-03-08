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

- Run commands in artifact_registry.md to upload latest built strapi docker image

- To deploy the latest Strapi commits, run the following commands
  - gcloud builds submit --tag us-central1-docker.pkg.dev/coworkout-250307/strapi-docker-repo/strapi-image-local:latest
  - gcloud run deploy strapi-image-local \
--image=us-central1-docker.pkg.dev/coworkout-250307/strapi-docker-repo/strapi-image-local:latest \
--allow-unauthenticated \
--vpc-connector=sample-servless-connector \
--region=us-central1 \
--vpc-egress=private-ranges-only \
--port=1337 \
--memory=2Gi \
--service-account=strapi \
--set-env-vars='^#^APP_KEYS=dvVL5fy+Y7YqhhbG2G/o9w==,+4FuGgS0J+isorche9DGmA==,eyX22XP9yxhHTSfpxa+5kQ==,9yf96xUfnE8fGL7zADY7MQ==' --set-env-vars=API_TOKEN_SALT=fzfyMtPc3NaPHVAWjmWPfw== --set-env-vars='ADMIN_JWT_SECRET=IJL8hF/vViCh8NKE7Wsv5A==' --set-env-vars='TRANSFER_TOKEN_SALT=b1VenQ/VZANQi8qLkM6+Kg==' --set-env-vars=DATABASE_HOST=10.30.96.3 \
--project=coworkout-250307
