# Docker

## build and push

```bash
PROJECT_ID="<YOUR_GCP_PROJECT_ID>" # Replace with your GCP project ID.
REGION="us-central1" # Replace with your desired region.
```

### 1. Enable Artifact Registry API (if not already enabled)

gcloud services enable artifactregistry.googleapis.com --project="$PROJECT_ID"

### 2. Create a Docker repository in Artifact Registry (if it doesn't exist)

gcloud artifacts repositories create node-app-repo \
    --repository-format=docker \
    --location="$REGION" \
    --project="$PROJECT_ID"

### 3. Migrate existing Container Registry images to Artifact Registry

gcloud artifacts docker upgrade migrate \
    --project="$PROJECT_ID"

### 4. Build and push your Docker image to Artifact Registry

docker build -t "$REGION-docker.pkg.dev/$PROJECT_ID/node-app-repo/node-app:latest" .
docker push "$REGION-docker.pkg.dev/$PROJECT_ID/node-app-repo/node-app:latest"

### Alternative: Using Cloud Build and cloudbuild.yaml

```bash
cat <<EOF > cloudbuild.yaml
steps:
  - name: "gcr.io/cloud-builders/docker"
    args:
      - "build"
      - "-t"
      - "${REGION}-docker.pkg.dev/${PROJECT_ID}/node-app-repo/node-app:latest"
      - "."
    timeout: "7200s"
  - name: "gcr.io/cloud-builders/docker"
    args:
      - "push"
      - "${REGION}-docker.pkg.dev/${PROJECT_ID}/node-app-repo/node-app:latest"
images:
  - "${REGION}-docker.pkg.dev/${PROJECT_ID}/node-app-repo/node-app:latest"
EOF

gcloud builds submit --config cloudbuild.yaml --substitutions=REGION="${REGION}",PROJECT_ID="${PROJECT_ID}" .
```

### 5. Verify the image in Artifact Registry

```bash
gcloud artifacts docker images list "$REGION-docker.pkg.dev/$PROJECT_ID/node-app-repo"
```

## links

[GCP deployment](https://medium.com/google-cloud/strapi-headless-cms-google-cloud-run-and-postgresql-6126b597b10c)
