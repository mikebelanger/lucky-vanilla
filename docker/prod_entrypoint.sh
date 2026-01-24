#!/bin/bash

set -euo pipefail

# This is the entrypoint script used for development docker workflows.
# By default it will:
#  - Install dependencies.
#  - Run migrations.
#  - Start the dev server.
# It also accepts any commands to be run instead.


warnfail () {
  echo "$@" >&2
  exit 1
}

case ${1:-} in
  "") # If no arguments are provided, start lucky dev server.
    ;;

  *) # If any arguments are provided, execute them instead.
    exec "$@"
esac

if ! [ -d bin ] ; then
  echo 'Creating bin directory'
  mkdir bin
fi
if ! shards check ; then
  echo 'Installing shards...'
  shards install
fi

echo 'Waiting for postgres to be available...'

./docker/wait-for-it.sh $POD:$POSTGRES_PORT

crystal build --release src/start_server.cr
crystal build --release tasks.cr -o bin/cli

crystal run tasks.cr -- db.migrate
SECRET_KEY_BASE=$(openssl rand -base64 32) shards build vanilla_app
# cd src/ts
# npm install
# npm run dev
# cd ../..
echo 'Starting vanilla...'
# exec lucky dev --error-trace

# cd bin
# bin/start_server
crystal build src/start_server.cr -o ./bin/start_server
chmod ug+x ./bin/start_server
./bin/start_server
