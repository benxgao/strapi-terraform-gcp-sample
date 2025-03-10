# coworkout-strapi

## Development in local env

```bash
cd strapi-server
docker-compose up -- build
docker-compose down
docker-compose up
```

## GCP setup

```bash
# Via local CLI
cd terraform/environments/init
terraform plan
terraform apply 
```

## Manage GCP staging env

```bash
# Via local CLI
cd terraform/environments/staging
terraform plan
terraform apply


# Via CircleCI
gco terraform-staging
gp
```

## Deploy Strapi to Cloud Run in staging env

```bash
# Via local CLI
# Check commands in docs/gcp.md

# Via CircleCI
gco strapi-staging
gp
```
