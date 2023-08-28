#!/bin/bash

echo "docker run"
docker run --name lion-db -d -p 5432:5432 \
    --env-file .env \
    -v postgres-data:/var/lib/postgresql/data \
    postgres:13
