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

## Build and publish docker image (deprecated)

### 1. Authenticate with gcloud

gcloud auth login
gcloud auth configure-docker #If you haven't done this before.
gcloud config set project <YOUR_GCP_PROJECT_ID>

### 2. Build the Docker image locally (optional, but good for testing)

docker build -t gcr.io/<YOUR_GCP_PROJECT_ID>/node-app:latest .

### 3. Push the Docker image to Google Container Registry (GCR)

docker push gcr.io/<YOUR_GCP_PROJECT_ID>/node-app:latest

### Alternative: Using Cloud Build (recommended for CI/CD)

gcloud builds submit --tag gcr.io/<YOUR_GCP_PROJECT_ID>/node-app:latest .

### Verify the image (optional)

gcloud container images list --repository gcr.io/<YOUR_GCP_PROJECT_ID>/node-app

### Example using the Cloud Build YAML file

```bash
cat <<EOF > cloudbuild.yaml
steps:
  - name: "gcr.io/cloud-builders/docker"
    args:
      - "build"
      - "-t"
      - "gcr.io/<YOUR_GCP_PROJECT_ID>/node-app:latest"
      - "."
    timeout: "7200s"
  - name: "gcr.io/cloud-builders/docker"
    args:
      - "push"
      - "gcr.io/<YOUR_GCP_PROJECT_ID>/node-app:latest"
images:
  - "gcr.io/<YOUR_GCP_PROJECT_ID>/node-app:latest"
EOF
```

```bash
gcloud builds submit --config cloudbuild.yaml .
```
