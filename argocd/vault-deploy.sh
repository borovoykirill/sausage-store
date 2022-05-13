#!/bin/bash
set +e
set -x

 
cat > VAULT_SECRETS_BASE64.txt <<EOF
${VAULT_SECRETS_BASE64}
EOF

cat VAULT_SECRETS_BASE64.txt | base64 --decode > .env
VAULT_SECRETS=$(cat .env)

# Удаляем файлы с секретами
rm -f VAULT_SECRETS_BASE64.txt
rm -f .env

docker rm -f vault
docker run -d --cap-add=IPC_LOCK --name vault -p 8200:8200 -e VAULT_DEV_ROOT_TOKEN_ID=$VAULT_TOKEN -e 'VAULT_SERVER=http://127.0.0.1:8200' -e 'VAULT_ADDR=http://127.0.0.1:8200' vault
sleep 5
docker exec -i vault ash -c "vault login $VAULT_TOKEN ; vault kv put $VAULT_SECRETS ; vault kv get secret/sausage-store"

