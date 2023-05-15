FROM ubuntu

RUN apt-get -qq update && \
    apt-get -qq install -y krb5-user

COPY krb5.keytab /etc/krb5.keytab

COPY krb5.conf /etc/krb5.conf

COPY run.sh /run.sh

COPY cli .

RUN chmod +x /run.sh

CMD ["sleep", "3600"]
