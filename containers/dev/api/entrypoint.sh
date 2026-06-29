#!/bin/sh

until pg_isready -h "$POD" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
     echo 'Waiting for postgres to be available...'
     sleep 2
 done

cd app/

if ! [ -d bin ] ; then
  echo 'Creating bin directory'
  mkdir bin
fi

lucky db.create
lucky db.migrate

echo 'Starting vanilla...'
lucky dev
