#!/bin/bash
###

APISIX_VERSION=v0.7
APISIX_DOWNLOAD_URL=http://182.151.51.74:8000/apisix/v0.7.zip
APISIX_DASHBOARD_BUILTDOWNLOAD_URL=http://182.151.51.74:8000/apisix/a0b49ae9f75b62b6dd1215a5a42074bbaef685ed.zip

docker build -t apisix:${APISIX_VERSION}-alpine \
    --build-arg APISIX_VERSION=${APISIX_VERSION} \
    --build-arg APISIX_DOWNLOAD_URL=${APISIX_DOWNLOAD_URL} \
    --build-arg APISIX_DASHBOARD_BUILTDOWNLOAD_URL=${APISIX_DASHBOARD_BUILTDOWNLOAD_URL} \
     -f alpine/Dockerfile alpine
docker tag apisix:${APISIX_VERSION}-alpine apisix:latest

docker tag apisix:${APISIX_VERSION}-alpine linsir/apisix:${APISIX_VERSION}-alpine
docker tag apisix:${APISIX_VERSION}-alpine linsir/apisix:latest

docker push linsir/apisix:${APISIX_VERSION}-alpine
docker push linsir/apisix:latest
