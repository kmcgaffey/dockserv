FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update; 
RUN apt-get install -y apache2
RUN a2enmod ssl
RUN service apache2 restart
RUN mkdir /etc/apache2/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=US/ST=Georgia/L=Atlanta/O=Tatooine/OU=Weeaboo Department/CN=192.168.0.1"

RUN rm /etc/apache2/sites-available/default-ssl.conf

ADD 000-default-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf

RUN a2ensite default-ssl.conf
RUN service apache2 restart

EXPOSE 443

