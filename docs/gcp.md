# GCP

## ref

[](https://medium.com/google-cloud/strapi-headless-cms-google-cloud-run-and-postgresql-6126b597b10c)

## steps

```bash
export PROJECT_ID=coworkout-250306
export REGION=us-central1

gcloud config set project $PROJECT_ID

gcloud compute networks create vpc-sample-network \
--subnet-mode=auto \
--bgp-routing-mode=regional \
--mtu=1460 \
--description='Sample VPC Network' \
--project=$PROJECT_ID

gcloud compute addresses create google-managed-ip-vpc-sample-network \
 --global \
 --prefix-length=20 \
 --purpose=VPC_PEERING  \
 --network=vpc-sample-network \
 --project=$PROJECT_ID 


gcloud services vpc-peerings connect \
--service=servicenetworking.googleapis.com \
--ranges=google-managed-ip-vpc-sample-network \
--network=vpc-sample-network \
--project=$PROJECT_ID


gcloud beta sql instances create strapi-postgres-v14 \
--database-version=POSTGRES_14 \
--cpu=1 --memory=3840MB \
--region=us-central1 \
--network=vpc-sample-network \
--no-assign-ip \
--storage-size=10GB \
--enable-google-private-path

gcloud sql databases create strapi --instance=strapi-postgres-v14

gcloud sql users create strapi --instance=strapi-postgres-v14 --password=strapi


gcloud compute networks vpc-access connectors create sample-servless-connector \
--network=vpc-sample-network \
--region=us-central1 \
--range=10.9.0.0/28 \
--min-instances=2 \
--max-instances=3 \
--machine-type=f1-micro


gcloud iam service-accounts create strapi \
--description="Service Account for Strapi service" \
--display-name="Strapi"


gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:strapi@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/run.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:strapi@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/iam.serviceAccountUser"

## Build and publish images
gcloud builds submit --tag us-central1-docker.pkg.dev/coworkout-250306/strapi-docker-repo/strapi-image-local:latest

## Deploy instances
gcloud run deploy strapi-image-local \
--image=us-central1-docker.pkg.dev/coworkout-250306/strapi-docker-repo/strapi-image-local:latest \
--allow-unauthenticated \
--vpc-connector=sample-servless-connector \
--region=us-central1 \
--vpc-egress=private-ranges-only \
--port=1337 \
--memory=2Gi \
--service-account=strapi \
--set-env-vars='^#^APP_KEYS=dvVL5fy+Y7YqhhbG2G/o9w==,+4FuGgS0J+isorche9DGmA==,eyX22XP9yxhHTSfpxa+5kQ==,9yf96xUfnE8fGL7zADY7MQ==' --set-env-vars=API_TOKEN_SALT=fzfyMtPc3NaPHVAWjmWPfw== --set-env-vars='ADMIN_JWT_SECRET=IJL8hF/vViCh8NKE7Wsv5A==' --set-env-vars='TRANSFER_TOKEN_SALT=b1VenQ/VZANQi8qLkM6+Kg==' --set-env-vars=DATABASE_HOST=10.30.96.3 \
--project=coworkout-250306

```
