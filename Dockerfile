FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update; apt-get install -y \
	apache2 \
 	openssl \
	git

RUN rm -rf /var/www/html/*; rm -rf /etc/apache2/sites-enabled/*; \
    mkdir -p /etc/apache2/external

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN sed -i 's/^ServerSignature/#ServerSignature/g' /etc/apache2/conf-enabled/security.conf; \
    sed -i 's/^ServerTokens/#ServerTokens/g' /etc/apache2/conf-enabled/security.conf; \
    echo "ServerSignature Off" >> /etc/apache2/conf-enabled/security.conf; \
    echo "ServerTokens Prod" >> /etc/apache2/conf-enabled/security.conf; \
    a2enmod ssl; \
    a2enmod headers; \
    echo "SSLProtocol ALL -SSLv2 -SSLv3" >> /etc/apache2/apache2.conf

ADD 001-default-ssl.conf /etc/apache2/sites-enabled/001-default-ssl.conf

EXPOSE 443

RUN apt-get install git
RUN useradd -m -p empiredidnothingwrong git
RUN useradd -m -p empiredidnothingwrong admin
RUN mkdir /var/git/
RUN cd /var/git/
RUN git init --bare admin.git
ADD git.key.pub /var/git/git.key.pub

RUN cat /var/git/publickey.pub >> ~/.ssh/authorized_keys
RUN eval "$(ssh-agent -s)"
RUN ssh-add ~./ssh/authorized_keys

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
