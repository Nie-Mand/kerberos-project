FROM ubuntu

RUN apt-get -qq update && \
    apt-get -qq install -y locales krb5-kdc krb5-admin-server

COPY init-script.sh /tmp/

RUN chmod +x /tmp/init-script.sh

CMD ["/tmp/init-script.sh"]