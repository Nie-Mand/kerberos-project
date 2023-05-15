#!/bin/bash
echo "==================================================================================="
echo "==== Kerberos KDC and Kadmin ======================================================"
echo "==================================================================================="
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo ""

echo "==================================================================================="
echo "==== /etc/krb5.conf ==============================================================="
echo "==================================================================================="
KDC_KADMIN_SERVER=$(hostname -f)
tee /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = $REALM

[realms]
	$REALM = {
		kdc_ports = 88,750
		kadmind_port = 749
		kdc = $KDC_KADMIN_SERVER
		admin_server = $KDC_KADMIN_SERVER
	}
EOF
echo ""

echo "==================================================================================="
echo "==== /etc/krb5kdc/kdc.conf ========================================================"
echo "==================================================================================="
tee /etc/krb5kdc/kdc.conf <<EOF
[realms]
	$REALM = {
		acl_file = /etc/krb5kdc/kadm5.acl
		max_renewable_life = 7d 0h 0m 0s
		supported_enctypes = $SUPPORTED_ENCRYPTION_TYPES
		default_principal_flags = +preauth
	}
EOF
echo ""

echo "==================================================================================="
echo "==== /etc/krb5kdc/kadm5.acl ======================================================="
echo "==================================================================================="
tee /etc/krb5kdc/kadm5.acl <<EOF
$KADMIN_PRINCIPAL_FULL *
noPermissions@$REALM X
EOF
echo ""

echo "==================================================================================="
echo "==== Creating realm ==============================================================="
echo "==================================================================================="
MASTER_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
# This command also starts the krb5-kdc and krb5-admin-server services
krb5_newrealm <<EOF
$MASTER_PASSWORD
$MASTER_PASSWORD
EOF
echo ""

echo "==================================================================================="
echo "==== Creating default principals in the acl ======================================="
echo "==================================================================================="
echo "Adding $KADMIN_PRINCIPAL principal"
kadmin.local -q "delete_principal -force $KADMIN_PRINCIPAL_FULL"
echo ""
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD $KADMIN_PRINCIPAL_FULL"
echo ""

echo "==================================================================================="
echo "==== Creating Gosher Server Service Principal ====================================="
echo "==================================================================================="
echo "Adding $KGSERVICE_PRINCIPAL principal"
KGSERVICE_PRINCIPAL_FULL=$KGSERVICE_PRINCIPAL@$REALM
kadmin.local -q "delete_principal -force $KGSERVICE_PRINCIPAL_FULL"
echo ""
kadmin.local -q "addprinc -randkey $KGSERVICE_PRINCIPAL_FULL"
echo ""
echo "Adding Keytab of the $KGSERVICE_PRINCIPAL principal"
kadmin.local -q "ktadd -k /etc/$KGSERVICE_PRINCIPAL.keytab $KGSERVICE_PRINCIPAL"
echo ""

echo "==================================================================================="
echo "==== Creating The Consumer Client Principal ======================================="
echo "==================================================================================="
echo "Adding $KGCONSUMER_PRINCIPAL principal"
KGCONSUMER_PRINCIPAL_FULL=$KGCONSUMER_PRINCIPAL@$REALM
kadmin.local -q "delete_principal -force $KGCONSUMER_PRINCIPAL_FULL"
echo ""
kadmin.local -q "addprinc -pw $KGCONSUMER_PASSWORD $KGCONSUMER_PRINCIPAL_FULL"
echo ""
echo "Adding Keytab of the $KGCONSUMER_PRINCIPAL principal"
kadmin.local -q "ktadd -k /etc/$KGCONSUMER_PRINCIPAL.keytab $KGCONSUMER_PRINCIPAL"
echo ""




echo "Adding noPermissions principal"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD noPermissions@$REALM"
echo ""

krb5kdc
kadmind -nofork
