#!/bin/bash
set +e
cat > .backend_report_env <<EOF
SPRING_DATASOURCE_URL=${PSQL_DATASOURCE}
SPRING_DATASOURCE_USERNAME=${PSQL_USER}
SPRING_DATASOURCE_PASSWORD=${PSQL_PASSWORD}
SPRING_DATA_MONGODB_URI=${MONGO_DATA}
VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}

SPRING_CLOUD_VAULT_TOKEN=${VAULT_TOKEN}
SPRING_CLOUD_VAULT_HOST=${VAULT_HOST}
REPORT_PATH=${REPORT_PATH}
LOG_PATH=${REPORT_PATH}
EOF
docker login -u $CI_REGISTRY_LOGIN -p $CI_REGISTRY_PASSWORD_MANUAL $CI_REGISTRY_URL
docker network create -d bridge sausage_network || true
docker pull $CI_REGISTRY_IMAGE_BACKEND_REPORT
docker stop sausage-backend-report || true
docker rm -f sausage-backend-report || true
set -e
docker run -d --name sausage-backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .backend_report_env \
    $CI_REGISTRY_IMAGE_BACKEND_REPORT
