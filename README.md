# coworkout-strapi

## Development

```bash
cd strapi-server
docker-compose up -- build
docker-compose down
docker-compose up
```

## GCP setup

```bash
cd terraform/environments/init
terraform plan
terraform apply
```

## Staging deployment

```bash
cd terraform/environments/staging
terraform plan
terraform apply
```
