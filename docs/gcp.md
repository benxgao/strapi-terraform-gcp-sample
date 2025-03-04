# GCP

## ref

[](https://medium.com/google-cloud/strapi-headless-cms-google-cloud-run-and-postgresql-6126b597b10c)

## steps

```bash
gcloud compute networks vpc-access connectors create sample-servless-connector \
--network=vpc-sample-network \
--region=australia-southeast1 \
--range=10.152.0.0/28 \
--min-instances=2 \
--max-instances=3 \
--machine-type=f1-micro

gcloud beta sql instances create strapi-postgres-v14 \
--database-version=POSTGRES_14 \
--cpu=1 --memory=3840MB \
--region=australia-southeast1 \
--network=vpc-sample-network \
--no-assign-ip \
--storage-size=10GB \
--enable-google-private-path

gcloud run deploy strapi --image gcr.io/$PROJECT_ID/strapi-image-local \
--vpc-connector=sample-servless-connector \
--region=australia-southeast1 \
--vpc-egress=private-ranges-only \
--allow-unauthenticated \
--service-account=strapi
```
