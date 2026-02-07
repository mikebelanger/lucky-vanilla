SUFFIX="prod"
PORT=9000
RELOAD_PORT=9001
POD="vanilla_app_${SUFFIX}"
DATABASE_CONTAINER_NAME="vanilla_db_${SUFFIX}"
APP_NAME="vanilla_api_${SUFFIX}"
HOST="0.0.0.0"
APP_DOMAIN="http://localhost:${PORT}"
POSTGRES_DB="lucky_prod"
POSTGRES_PORT=5432
POSTGRES_USER="lucky"
POSTGRES_PASSWORD="password"
POSTGRES_DATA_DIR="./pg_data_${SUFFIX}"
TLD_DOMAIN="vanillasplit.com"
CADDY_DATA_DIR="./caddy_data"

# Test if podman pod exists already
podman pod exists "$POD" > /dev/null 2>&1
POD_EXISTS=$?

# If the pod does not already exist, then build it
if [ "$POD_EXISTS" -eq 1 ]; then
    # Create pod to group entire app
    podman pod create \
    --replace \
    -p 4430:443 \
    -p 8080:80 \
    --name $POD

    # make an empty data directory to volume-mount to the postgres container
    # Most environment variables will not take effect in the postgres container unless
    # you volume-mount an empty data directory:
    # https://hub.docker.com/_/postgres#environment-variables
    if [ ! -d $POSTGRES_DATA_DIR ]; then
        mkdir $POSTGRES_DATA_DIR
    fi

    # Same with caddy's data directory
    if [ ! -d $CADDY_DATA_DIR ]; then
        mkdir $CADDY_DATA_DIR
        sudo chmod 777 $CADDY_DATA_DIR
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
    --build-arg SECRET_KEY_BASE=$(openssl rand -base64 32) \
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
    -e SECRET_KEY_BASE=$(openssl rand -base64 32) \
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

    # Reverse proxy
    podman create \
    --name vanilla_reverse_proxy \
    --pod ${POD} \
    --cap-add=NET_ADMIN \
    --requires=${APP_NAME} \
    -v "${CADDY_DATA_DIR}:/data" \
    caddy caddy reverse-proxy --from "${TLD_DOMAIN}" --to "${POD}:${PORT}"
fi

podman pod start ${POD}
podman pod logs --color -n -f ${POD}
