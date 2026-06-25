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
SECRETS_YAML
  echo "Generated containers/dev/secrets.yml"
fi

# Unfortunately, kube play does not support implicit building in nested subdirectories:
# https://github.com/podman-container-tools/podman/issues/28418

podman build \
  -f containers/dev/api/Containerfile \
  -t localhost/vanilla_dev_api:latest \
  containers/dev/api

podman build \
  -f containers/dev/scheduler/Containerfile \
  -t localhost/vanilla_dev_scheduler:latest \
  containers/dev/scheduler

exec podman kube play \
  --configmap containers/dev/config.yml \
  --configmap containers/dev/secrets.yml \
  --replace \
  containers/dev/pod.yml
