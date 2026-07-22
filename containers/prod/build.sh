#!/usr/bin/env bash
set -euo pipefail

mkdir -p pg_data_prod

if [ ! -f containers/prod/secrets.yml ]; then
  cat > containers/prod/secrets.yml << SECRETS_YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: vanilla-prod-secrets
data:
  SECRET_KEY_BASE: $(openssl rand -base64 32)
  SEND_TOKEN: $(openssl rand -hex 15)
  POSTGRES_DB: lucky_prod
  POSTGRES_PASSWORD: password
  POSTGRES_PORT: 5432
  POSTGRES_USER: lucky
  APP_DOMAIN: http://localhost
  DATABASE_NAME: vanilla_db_prod
  DATABASE_URL: postgres://lucky:password@localhost:5432/lucky_prod
SECRETS_YAML
  echo "Generated containers/prod/secrets.yml"
fi

# Unfortunately, kube play does not support implicit building in nested subdirectories:
# https://github.com/podman-container-tools/podman/issues/28418
# which means commands like COPY ../ don't pick up on relative paths correctly
#
# So we explicitely build them first
podman build \
  -f containers/prod/api/Containerfile \
  -t localhost/vanilla_prod_api:latest \
  .

podman build \
  -f containers/prod/scheduler/Containerfile \
  -t localhost/vanilla_prod_scheduler:latest \
  containers/prod/scheduler

# Now spin it up
#
# subsequent runs can be done with:
#
# podman pod start vanilla_prod
#
# and stopped with
#
# podman pod stop vanilla_prod
exec podman kube play \
  --configmap containers/prod/config.yml \
  --configmap containers/prod/secrets.yml \
  --publish 9000:9000 \
  --publish 8080:8080 \
  --replace \
  containers/prod/pod.yml
