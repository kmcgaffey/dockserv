#!/bin/bash

apt-get update
	apt-get install \
	apt-transport-https \
	ca-certificates \ 
	curl \ 
	apt-get install software-properties-common \

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

if [[ $(apt-key fingerprint 0EBFCD88 | grep 'Key fingerprint' ) != 'Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88' ]]; then
	echo Docker GPG key mismatch
	exit
fi

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
apt-get install docker-ce 
