FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update; apt-get install -y apache2 openssl git git-core

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

ADD admin.key.pub /admin.key.pub
RUN chmod a+r /admin.key.pub
RUN adduser admin --gecos "obi wan,1337,mitichlorians,phonehome" --disabled-password
RUN echo "admin:empiredidnothingwrong" | sudo chpasswd
RUN su - admin $ mkdir .ssh && chmod 700 .ssh $ touch .ssh/authorized_keys $ chmod 600 .ssh/authorized_keys
RUN cat /admin.key.pub >> \ /home/admin/.ssh/authorized_keys
RUN su
RUN grep git-shell /etc/shells || su -c \ "echo `which git-shell` >> /etc/shells" # su -c 'usermod -s git-shell admin'
RUN usermod -a -G admin root
RUN git init --bare /opt/admin.git
RUN chown -R admin:admin /opt/admin.git
RUN chmod -R 770 /opt/admin.git

ADD post-push /opt/admin/.git/hooks/post-push
RUN chmod +771 /opt/admin/.git/hooks/post-push

EXPOSE 22

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
