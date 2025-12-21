declare -r PORT=8000
declare -r RELOAD_PORT=8001
declare -r POD="vanilla_app_dev"
declare -r DATABASE_NAME="vanilla_postgres_dev"
declare -r APP_NAME="vanilla_api_dev"

podman pod create \
--replace \
-p $PORT:$PORT \
--name $POD

podman create \
--replace \
--name $DATABASE_NAME \
-v postgres_data:/var/lib/postgresql/data \
-e POSTGRES_USER=lucky \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_DB=lucky \
--pod $POD \
postgres:14-alpine

podman create \
--replace \
--name vanilla_api_dev \
--requires=$DATABASE_NAME \
-v /home/mike/.local/share/containers/storage/volumes/vanilla-app_postgres_data/_data \
-v .:/app \
-v node_modules:/app/node_modules \
-v shards_lib:/app/lib \
-v app_bin:/app/bin \
-v build_cache:/root/.cache \
--entrypoint=docker/dev_entrypoint.sh \
-e DATABASE_URL=postgres://lucky:password@${DATABASE_NAME}:5432/lucky \
-e DEV_HOST="0.0.0.0" \
-e RELOAD_PORT=$RELOAD_PORT \
--pod $POD \
localhost/vanilla-app_lucky:latest

podman build -f docker/scheduler.dockerfile --no-cache -t scheduler_dev
podman create \
--pod $POD \
--requires=vanilla_api_dev \
-e HOST_URL="$POD:$PORT" \
scheduler_dev

podman pod start $POD
