# dockserv
A docker container hosting a web and git server that executes scripts on upload

Ensure all docker dependencies are installed

In order for the ssl certificates to work you must modify the Dockerfile openssl command to make the common name "CN=192.168.0.1" to whatever your public IP or domain name is.
