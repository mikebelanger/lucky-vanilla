SUFFIX="dev"
PORT=8888
RELOAD_PORT=8889
POD="vanilla_app_${SUFFIX}"
DATABASE_CONTAINER_NAME="vanilla_db_${SUFFIX}"
APP_NAME="vanilla_api_${SUFFIX}"
HOST="0.0.0.0"
APP_DOMAIN="http://localhost:${PORT}"
POSTGRES_DB="lucky_dev"
POSTGRES_PORT=5432
POSTGRES_USER="lucky"
POSTGRES_PASSWORD="password"
POSTGRES_DATA_DIR="./pg_data_${SUFFIX}"
SEND_TOKEN=$(openssl rand -base64 32)

# Create pod to group entire app
podman pod create \
--replace \
-p $PORT:$PORT \
--name $POD

# make an empty data directory to volume-mount to the postgres container
# Most environment variables will not take effect in the postgres container unless
# you volume-mount an empty data directory:
# https://hub.docker.com/_/postgres#environment-variables
if [ ! -d $POSTGRES_DATA_DIR ]; then
    mkdir $POSTGRES_DATA_DIR
fi

# Build database part
podman create \
--replace \
--name ${DATABASE_CONTAINER_NAME} \
-e POSTGRES_USER=${POSTGRES_USER} \
-e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
-e POSTGRES_DB=${POSTGRES_DB} \
-e POSTGRES_PORT=${POSTGRES_PORT} \
-v "${POSTGRES_DATA_DIR}:/var/lib/postgresql/data" \
--pod ${POD} \
postgres:14-alpine

# Build api (lucky) image
podman build \
--build-arg SECRET_KEY_BASE=$(lucky gen.secret_key) \
-f docker/development.dockerfile --no-cache -t "vanilla_api_${SUFFIX}_base" .

# Create the API image
podman create \
--replace \
--name ${APP_NAME} \
--requires=${DATABASE_CONTAINER_NAME} \
-v .:/app:z \
-e SEND_GRID_KEY=unused \
-e DATABASE_URL="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POD}:${POSTGRES_PORT}/${POSTGRES_DB}" \
-e DATABASE_NAME=${DATABASE_CONTAINER_NAME} \
-e LUCKY_ENV=development \
-e APP_DOMAIN=${APP_DOMAIN} \
-e SECRET_KEY_BASE=$(lucky gen.secret_key) \
-e PORT=${PORT} \
-e HOST=${POD} \
-e POD=${POD} \
-e POSTGRES_PORT=${POSTGRES_PORT} \
-e SEND_TOKEN=${SEND_TOKEN} \
--entrypoint=docker/dev_entrypoint.sh \
--pod ${POD} \
"vanilla_api_${SUFFIX}_base"

# Create the TS (frontend) asset page
podman create \
--replace \
--name vanilla_frontend_dev \
-v ./src/ts:/app \
-v ./public:/public \
-w /app \
--pod vanilla_app_dev \
oven/bun:latest dev

# Create periodic scheduler designed to 'ping' the lucky app at a given interval
podman build -f docker/scheduler.dockerfile --no-cache -t "vanilla_scheduler_${SUFFIX}_base"

podman create \
--name "vanilla_scheduler_${SUFFIX}" \
--pod ${POD} \
--requires=${APP_NAME} \
-e HOST_URL="${POD}:${PORT}" \
-e SEND_TOKEN=${SEND_TOKEN} \
"vanilla_scheduler_${SUFFIX}_base"

podman pod start $POD
podman pod logs --color -n -f $POD
