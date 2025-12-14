podman network create vanilla_net 2>$null

podman run --replace \
--name=vanilla_postgres \
--network=vanilla_net \
-v postgres_data:/var/lib/postgresql/data \
-e POSTGRES_USER=lucky \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_DB=lucky \
-p 6543:5432 \
-d \
postgres:14-alpine

podman run --replace \
--name=vanilla_app \
--requires=vanilla_postgres \
-v /home/mike/.local/share/containers/storage/volumes/vanilla-app_postgres_data/_data \
-v .:/app \
-v node_modules:/app/node_modules \
-v shards_lib:/app/lib \
-v app_bin:/app/bin \
-v build_cache:/root/.cache \
-p 3000:3000 \
-p 3001:3001 \
--entrypoint=docker/dev_entrypoint.sh \
-e DATABASE_URL=postgres://lucky:password@vanilla_postgres:5432/lucky \
-e DEV_HOST="0.0.0.0" \
--network=vanilla_net \
localhost/vanilla-app_lucky:latest

podman run --replace \
-d \
--name=scheduler \
--requires=vanilla_app \
--network=vanilla_net \
-e HOST_URL=vanilla_app \
-p 6789:6789 \
localhost/scheduler:latest
