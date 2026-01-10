declare -r SUFFIX="prod"
declare -r PORT=9000
declare -r RELOAD_PORT=9001
declare -r POD="vanilla_app_${SUFFIX}"
declare -r DATABASE_CONTAINER_NAME="vanilla_postgres_${SUFFIX}"
declare -r APP_NAME="vanilla_api_${SUFFIX}"
declare -r HOST="127.0.0.1"
declare -r APP_DOMAIN="http://localhost:${PORT}"
declare -r POSTGRES_DB="vanilla_db"
declare -r POSTGRES_PORT=5432
declare -r POSTGRES_USER="lucky"
declare -r POSTGRES_PASSWORD="password"

# Create pod to group entire app
podman pod create \
--replace \
-p $PORT:$PORT \
--name $POD

# Build database part
podman create \
--replace \
--name $DATABASE_CONTAINER_NAME \
-v postgres_data:/var/lib/postgresql/data \
-e POSTGRES_USER=lucky \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_DB=$POSTGRES_DB \
-e POSTGRES_PORT=$POSTGRES_PORT \
--pod $POD \
postgres:14-alpine

# Build api (lucky) image
podman build -f docker/production.dockerfile --no-cache -t "vanilla_api_${SUFFIX}_base" .

# Spin it up
podman create \
--replace \
--name $APP_NAME \
--requires=$DATABASE_CONTAINER_NAME \
-v .:/app \
-e SEND_GRID_KEY=unused \
-e DATABASE_URL="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POD}:${POSTGRES_PORT}/${POSTGRES_DB}" \
-e DATABASE_NAME=${DATABASE_CONTAINER_NAME} \
-e LUCKY_ENV=production \
-e APP_DOMAIN=$APP_DOMAIN \
-e SECRET_KEY_BASE=$(lucky gen.secret_key) \
-e PORT=$PORT \
-e HOST=$HOST \
-e POSTGRES_PORT=$POSTGRES_PORT \
--entrypoint=docker/prod_entrypoint.sh \
--pod $POD \
vanilla_api_base

# Create periodic scheduler designed to 'ping' the lucky app at a given interval
podman build -f docker/scheduler.dockerfile --no-cache -t "vanilla_scheduler_${SUFFIX}_base"

podman create \
--name "vanilla_scheduler_${SUFFIX}" \
--pod $POD \
--requires=$APP_NAME \
-e HOST_URL="${POD}:${PORT}" \
"vanilla_scheduler_${SUFFIX}_base"

podman pod start $POD
