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
SECRETS_YAML
  echo "Generated containers/prod/secrets.yml"
fi

# Unfortunately, kube play does not support implicit building in nested subdirectories:
# https://github.com/podman-container-tools/podman/issues/28418

podman build \
  -f containers/prod/api/Containerfile \
  -t localhost/vanilla_prod_api:latest \
  containers/prod/api

podman build \
  -f containers/prod/scheduler/Containerfile \
  -t localhost/vanilla_prod_scheduler:latest \
  containers/prod/scheduler

exec podman kube play \
  --configmap containers/prod/config.yml \
  --configmap containers/prod/secrets.yml \
  --publish 80:80 \
  --publish 443:443 \
  --replace \
  containers/prod/pod.yml
