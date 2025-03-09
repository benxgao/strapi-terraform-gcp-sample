# Artifact Registry

```bash
gcloud auth configure-docker us-central1-docker.pkg.dev

export PROJECT_ID="coworkout-250307"
export ARTIFACT_REGISTRY_REPO="strapi-docker-repo"
export ARTIFACT_REGISTRY_LOCATION="us-central1"
# export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
# export SERVICE_ACCOUNT="$PROJECT_NUMBER-compute@developer.gserviceaccount.com"

gcloud artifacts repositories create "$ARTIFACT_REGISTRY_REPO" \
    --repository-format=docker \
    --location="$ARTIFACT_REGISTRY_LOCATION" 

export ARTIFACT_REGISTRY_IMAGE_TAG="${ARTIFACT_REGISTRY_LOCATION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REGISTRY_REPO}/strapi-image-local:latest"

# gcloud builds submit --tag "$ARTIFACT_REGISTRY_IMAGE_TAG"
gcloud builds submit --tag "us-central1-docker.pkg.dev/coworkout-250307/strapi-docker-repo/strapi-image-local:latest"
```
