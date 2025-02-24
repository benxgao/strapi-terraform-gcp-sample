# coworkout-strapi

## backend - stripi-server

### Start strpi

```bash
npx create-strapi@latest strapi-server

docker pull postgres:14.5
# docker run -d --name postgres145 -p 5432:5432 -e POSTGRES_PASSWORD=admin postgres:14.5
docker run -d --name postgres145 -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:14.5

docker exec -it postgres145 psql -h localhost -U postgres

npm run develop

```

## frontend - next-app

### Start next

```bash
```

## infrastruture - terraform

### Deploy

```bash
```
