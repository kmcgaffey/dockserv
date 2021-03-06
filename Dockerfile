FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update; apt-get install -y apache2 openssl openssh-server git git-core
RUN echo "root:empiredidnothingwrong" | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermidRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

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
RUN mkdir -p "/home/admin/.ssh"
RUN chmod 700 /home/admin/.ssh
RUN touch /home/admin/.ssh/authorized_keys
RUN chmod 600 /home/admin/.ssh/authorized_keys
RUN chmod -R +777 /home/admin
RUN cat /admin.key.pub >> /home/admin/.ssh/authorized_keys

RUN usermod -a -G admin root
RUN git init --bare /opt/admin.git
RUN git clone /opt/admin.git /opt/admin
RUN chown -R admin:admin /opt/admin.git
RUN chown -R admin:admin /opt/admin
RUN chmod -R 770 /opt/admin

ADD post-receive /opt/admin.git/hooks/post-receive
RUN chmod +777 /opt/admin.git/hooks/post-receive
RUN echo "No scripts run yet" > /var/www/html/index.html
RUN chown admin:admin /var/www/html/index.html
RUN chmod +777 /var/www/html

EXPOSE 22

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
