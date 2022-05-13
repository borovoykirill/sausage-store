#!/bin/bash
set +e
cat > .backend_env <<EOF
SPRING_CLOUD_VAULT_TOKEN=${VAULT_TOKEN}
SPRING_CLOUD_VAULT_HOST=${VAULT_HOST}
REPORT_PATH=${REPORT_PATH}
LOG_PATH=${REPORT_PATH}
EOF
docker login -u $CI_REGISTRY_LOGIN -p $CI_REGISTRY_PASSWORD_MANUAL $CI_REGISTRY_URL
docker network create -d bridge sausage_network || true
docker pull $CI_REGISTRY_IMAGE_BACKEND
docker stop sausage-backend || true
docker rm -f sausage-backend || true
set -e
docker run -d --name sausage-backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .backend_env \
    $CI_REGISTRY_IMAGE_BACKEND
