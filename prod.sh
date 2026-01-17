declare -r SUFFIX="prod"
declare -r PORT=9000
declare -r RELOAD_PORT=9001
declare -r POD="vanilla_app_${SUFFIX}"
declare -r DATABASE_CONTAINER_NAME="vanilla_postgres_${SUFFIX}"
declare -r APP_NAME="vanilla_api_${SUFFIX}"
declare -r HOST="0.0.0.0"
declare -r APP_DOMAIN="http://localhost:${PORT}"
declare -r POSTGRES_DB="lucky_prod"
declare -r POSTGRES_PORT=5432
declare -r POSTGRES_USER="lucky"
declare -r POSTGRES_PASSWORD="password"
declare -r POSTGRES_DATA_DIR="./pg_data_${SUFFIX}"

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
-v postgres_data:/var/lib/postgresql/data \
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
-f docker/production.dockerfile --no-cache -t "vanilla_api_${SUFFIX}_base" .

# Spin it up
podman create \
--replace \
--name ${APP_NAME} \
--requires=${DATABASE_CONTAINER_NAME} \
-v .:/app \
-e SEND_GRID_KEY=unused \
-e DATABASE_URL="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POD}:${POSTGRES_PORT}/${POSTGRES_DB}" \
-e DATABASE_NAME=${DATABASE_CONTAINER_NAME} \
-e LUCKY_ENV=production \
-e APP_DOMAIN=${APP_DOMAIN} \
-e SECRET_KEY_BASE=$(lucky gen.secret_key) \
-e PORT=${PORT} \
-e HOST=${POD} \
-e POD=${POD} \
-e POSTGRES_PORT=${POSTGRES_PORT} \
--entrypoint=docker/prod_entrypoint.sh \
--pod ${POD} \
"vanilla_api_${SUFFIX}_base"

# Create periodic scheduler designed to 'ping' the lucky app at a given interval
podman build -f docker/scheduler.dockerfile --no-cache -t "vanilla_scheduler_${SUFFIX}_base"

podman create \
--name "vanilla_scheduler_${SUFFIX}" \
--pod ${POD} \
--requires=${APP_NAME} \
-e HOST_URL="${POD}:${PORT}" \
"vanilla_scheduler_${SUFFIX}_base"

podman pod start $POD
podman pod logs --color -n -f $POD
