#!/bin/sh

echo 'Waiting for postgres to be available...'

until pg_isready -h "$POD" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
    sleep 2
done

cd app/
lucky db.create
lucky db.migrate

echo 'Starting vanilla...'
./bin/start_server
