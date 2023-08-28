#!/bin/bash

export (cat .env | xargs)

# docker login
docker login devops6th-cr.kr.ncr.ntruss.com \
    -u "" \
    -p ""

# image pull
docker pull devops6th-cr.kr.ncr.ntruss.com/lion-app:latest

# docker run
docker run -p 8000:8000 -d \
    --env-file .env \
    --name lion-app \
    devops6th-cr.kr.ncr.ntruss.com/lion-app:latest
