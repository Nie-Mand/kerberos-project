# Move the consumer keytab
echo "Move the consumer keytab"
sudo docker cp with-kerberos-krb5-1:/etc/gosher-consumer.keytab ./consumer/krb5.keytab
sudo docker exec -it with-kerberos-krb5-1 md5sum /etc/gosher-consumer.keytab
sudo md5sum ./consumer/krb5.keytab
echo ""

# Move the server keytab
echo "Move the server keytab"
sudo docker cp with-kerberos-krb5-1:/etc/gosher-serv.keytab ./serv/krb5.keytab
sudo docker exec -it with-kerberos-krb5-1 md5sum /etc/gosher-serv.keytab
sudo md5sum ./serv/krb5.keytab
echo ""


# Only While Test
echo "Only While Test"

sudo cp ./consumer/krb5.keytab ../../test/k5/consumer.keytab
sudo cp ./serv/krb5.keytab ../../test/sv/serv.keytab
sudo md5sum ../../test/k5/consumer.keytab
sudo md5sum ../../test/sv/serv.keytab



