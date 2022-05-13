#!/bin/bash
set +e
docker login -u $CI_REGISTRY_LOGIN -p $CI_REGISTRY_PASSWORD_MANUAL $CI_REGISTRY_URL
docker network create -d bridge sausage_network || true
docker pull $CI_REGISTRY_IMAGE_FRONTEND
docker stop sausage-frontend || true
docker rm sausage-frontend || true
set -e
docker run -d --name sausage-frontend \
    --network=sausage_network \
    -p 80:80 \
    --restart always \
    --pull always \
    $CI_REGISTRY_IMAGE_FRONTEND