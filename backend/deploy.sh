#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe


#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo service sausage-store-backend stop||true
sudo cp -rf /home/jarservice/sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo rm -f /home/jarservice/*.jar||true

# Скачиваем обновленный файл .jar
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-${VERSION}.jar ${NEXUS_REPO_URL}/${NEXUS_REPO_BACK}/${VERSION}/sausage-store-${VERSION}.jar
 
#Переносим артефакт в нужную папку
sudo cp ./sausage-store-${VERSION}.jar /home/jarservice/sausage-store.jar||true #"jar||true" говорит, если команда обвалится — продолжай
sudo rm -f /home/jarservice/sausage-store-${VERSION}.jar

#Меняем пользователя и группу на файлы
sudo chown -R jarservice:jarservice /home/jarservice/

# Сохраняем файл с переменными окружения для sausage-store-backend
sudo rm -f /etc/sysconfig/sausage-store
sudo rm -f /tmp/sausage-store
echo "REPORT_PATH=/log/reports" >> /tmp/sausage-store
echo "LOG_PATH=/log" >> /tmp/sausage-store
echo "PSQL_ADMIN=$PSQL_ADMIN" >> /tmp/sausage-store
echo "PSQL_USER=$PSQL_USER" >> /tmp/sausage-store
echo "PSQL_PASSWORD=$PSQL_PASSWORD" >> /tmp/sausage-store
echo "PSQL_HOST=$PSQL_HOST" >> /tmp/sausage-store
echo "PSQL_PORT=$PSQL_PORT" >> /tmp/sausage-store
echo "PSQL_DBNAME=$PSQL_DBNAME" >> /tmp/sausage-store
echo "MONGODB_HOST=$MONGODB_HOST" >> /tmp/sausage-store
echo "MONGODB_PORT=$MONGODB_PORT" >> /tmp/sausage-store
echo "MONGODB_USER=$MONGODB_USER" >> /tmp/sausage-store
echo "MONGODB_PASS=$MONGODB_PASS" >> /tmp/sausage-store
echo "MONGODB_DB=$MONGODB_DB" >> /tmp/sausage-store
sudo mv /tmp/sausage-store /etc/sysconfig/sausage-store
sudo chmod 600 /etc/sysconfig/sausage-store

#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#sudo systemctl enable sausage-store-backend

#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
