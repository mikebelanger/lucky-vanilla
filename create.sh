podman pod create \
--replace \
-p 3000:3000 \
--name vanilla_app

podman create \
--replace \
--name vanilla_postgres \
-v postgres_data:/var/lib/postgresql/data \
-e POSTGRES_USER=lucky \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_DB=lucky \
--pod vanilla_app \
postgres:14-alpine

podman create \
--replace \
--name vanilla_api \
--requires=vanilla_postgres \
-v /home/mike/.local/share/containers/storage/volumes/vanilla-app_postgres_data/_data \
-v .:/app \
-v node_modules:/app/node_modules \
-v shards_lib:/app/lib \
-v app_bin:/app/bin \
-v build_cache:/root/.cache \
--entrypoint=docker/dev_entrypoint.sh \
-e DATABASE_URL=postgres://lucky:password@vanilla_postgres:5432/lucky \
-e DEV_HOST="0.0.0.0" \
--pod vanilla_app \
localhost/vanilla-app_lucky:latest

podman build -f docker/scheduler.dockerfile --no-cache -t scheduler
podman create \
--pod vanilla_app \
--requires=vanilla_api \
-e HOST_URL=vanilla_app \
scheduler
