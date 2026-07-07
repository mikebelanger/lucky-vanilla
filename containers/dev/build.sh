#!/usr/bin/env bash
set -euo pipefail

mkdir -p pg_data_dev

if [ ! -f containers/dev/secrets.yml ]; then
  cat > containers/dev/secrets.yml << SECRETS_YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: vanilla-dev-secrets
data:
  SECRET_KEY_BASE: $(openssl rand -base64 32)
  SEND_TOKEN: $(openssl rand -hex 15)
  POSTGRES_DB: lucky_dev
  POSTGRES_PASSWORD: password
  POSTGRES_PORT: "5432"
  POSTGRES_USER: lucky
  APP_DOMAIN: http://localhost:8888
  DATABASE_NAME: vanilla_db_dev
  DATABASE_URL: postgres://lucky:password@vanilla-dev:5432/lucky_dev
SECRETS_YAML
  echo "Generated containers/dev/secrets.yml"
fi

# Unfortunately, kube play does not support implicit building in nested subdirectories:
# https://github.com/podman-container-tools/podman/issues/28418
# which means commands like COPY ../ don't pick up on relative paths correctly
#
# So we explicitely build them first
podman build \
  -f containers/dev/api/Containerfile \
  -t localhost/vanilla_dev_api:latest \
  --no-cache \
  containers/dev/api

podman build \
  -f containers/dev/scheduler/Containerfile \
  -t localhost/vanilla_dev_scheduler:latest \
  containers/dev/scheduler

# Podman Kube play doesn't always apply SELinux labels correctly, so we have to explictly add them here
# Pre-label volumes for SELinux
podman run --rm -v .:/z:z crystallang/crystal:latest true
podman run --rm -v ./src/ts:/z:z crystallang/crystal:latest true
podman run --rm -v ./public:/z:z crystallang/crystal:latest true

# Now spin it up
#
# subsequent runs can be done with:
#
# podman pod start vanilla-dev
#
# and stopped with
#
# podman pod stop vanilla-dev
exec podman kube play \
  --configmap containers/dev/config.yml \
  --configmap containers/dev/secrets.yml \
  --publish 8888:8888 \
  --replace \
  containers/dev/pod.yml
