#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe

# Предварительно разрешаем для пользователя jarservice запускать приложение на порту 80
# sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\``

#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo service sausage-store-frontend stop||true
sudo cp -rf /home/jarservice/sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo rm -f /home/jarservice/*.tar.gz||true
sudo rm -rf /home/jarservice/public_html||true
 
# Скачиваем обновленный файл .tar.gz
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-${VERSION}.tar.gz ${NEXUS_REPO_URL}/${NEXUS_REPO_FRONT}/${VERSION}/sausage-store-${VERSION}.tar.gz
tar -xvf sausage-store-${VERSION}.tar.gz
mv sausage-store-${VERSION}/* /home/jarservice/||true

#Меняем пользователя и группу на файлы
sudo chown -R jarservice:jarservice /home/jarservice/

#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload

#Перезапускаем сервис сосисочной 
sudo systemctl restart sausage-store-frontend
