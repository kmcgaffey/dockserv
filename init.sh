#!/bin/bash

apt-get update
apt-get --assume-yes install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#if [[ $(apt-key fingerprint 0EBFCD88 | grep 'Key fingerprint' ) != 'Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88' ]]; then
#        echo Docker GPG key mismatch
#        exit
#fi

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install docker-ce docker-compose

adduser admin --gecos "obi wan,1337,mitichlorians,phonehome" --disabled-password
echo "admin:empiredidnothingwrong" | sudo chpasswd
su - admin -c yes "" | ssh-keygen -t rsa -b 4096 -N "" -f admin.key

docker build -t tatooine .
docker run -d -p 443:443 -p 22:22 -v $EXT_DIR:/etc/apache2/external/ tatooine

#docker exec -it container_name bash
