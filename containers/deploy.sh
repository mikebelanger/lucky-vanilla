#!/bin/sh
podman pull ghcr.io/me/vanilla_prod_api:latest
podman pull ghcr.io/me/vanilla_prod_scheduler:latest
exec podman kube play --replace \
  --configmap ./prod/config.yml \
  --configmap ./prod/secrets.yml \
  ./prod/pod.yml
