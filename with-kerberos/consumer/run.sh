#!/bin/bash


echo "==================================================================================="
echo "==== Generating TGT ==============================================================="
echo "==================================================================================="
kinit -kt /etc/krb5.keytab $PRINCIPAL@$REALM
echo ""
echo "Done"
echo ""

echo "==================================================================================="
klist
echo ""