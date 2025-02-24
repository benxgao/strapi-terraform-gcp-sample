# coworkout-strapi

## backend - stripi-server

### Local

#### Attempt 1 (failed)

```bash
npx create-strapi@latest strapi-server

docker pull postgres:14.5
# docker run -d --name postgres145 -p 5432:5432 -e POSTGRES_PASSWORD=admin postgres:14.5
docker run -d --name postgres145 -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:14.5

docker exec -it postgres145 psql -h localhost -U postgres

npm run develop

```

#### Attempt 2 (succeeded)

```bash

npx @strapi-community/dockerize new --dbclient=postgres --dbhost=localhost --dbport=5432 --dbname=strapi --dbusername=strapi --dbpassword=strapi --projecttype=ts --packagemanager=npm --usecompose=true --env=both

# first run, or dockerfile/package.json is updated
docker-compose up --build
# for refresh
docker compose up --build --force-recreate


# dev
docker-compose up # docker-compose watch
docker-compose down

# when code is updated
docker compose restart mystrapi
docker compose restart


```

## infrastruture - terraform

### Attempt 1

```bash
gcloud builds submit --config cloudbuild.yaml 
```

### Attempt 2

```bash
docker build -f Dockerfile.prod -t "australia-southeast1-docker.pkg.dev/coworkout-20230409/mystrapi-repository/node-app:latest" .
```
