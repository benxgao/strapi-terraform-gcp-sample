# GCP

## ref

[](https://medium.com/google-cloud/strapi-headless-cms-google-cloud-run-and-postgresql-6126b597b10c)

## steps

```bash
gcloud run deploy strapi-image-local \
--image=gcr.io/coworkout-250305/strapi-image-local@sha256:208ecab22baa251a3d62feb2e13034f3ebbd434725a0ccafdf3334d30e5fa809 \
--allow-unauthenticated \
--vpc-connector=sample-servless-connector \
--region=us-central1 \
--vpc-egress=private-ranges-only \
--port=1337 \
--memory=2Gi \
--service-account=strapi \
--set-env-vars='^#^APP_KEYS=dvVL5fy+Y7YqhhbG2G/o9w==,+4FuGgS0J+isorche9DGmA==,eyX22XP9yxhHTSfpxa+5kQ==,9yf96xUfnE8fGL7zADY7MQ==' --set-env-vars=API_TOKEN_SALT=fzfyMtPc3NaPHVAWjmWPfw== --set-env-vars='ADMIN_JWT_SECRET=IJL8hF/vViCh8NKE7Wsv5A==' --set-env-vars='TRANSFER_TOKEN_SALT=b1VenQ/VZANQi8qLkM6+Kg==' --set-env-vars=DATABASE_HOST=10.34.80.3 \
--project=coworkout-250305
```
