#!/bin/bash
set -e
psql -v openfire_db_owner="$OPENFIRE_DB_OWNER" \
     -v openfire_db="$OPENFIRE_DB"             \
     -v openfire_db_password="$OPENFIRE_DB_PASSWORD" \
     -f docker-entrypoint-initdb.d/sql/create_db.sql
perl  docker-entrypoint-initdb.d/encoder.pl "docker-entrypoint-initdb.d/sql/openfire.sql" "cn=admin,$LDAP_BASE_DN" "$LDAP_ADMIN_PASSWORD"
psql --dbname="$OPENFIRE_DB" \
     --username="$OPENFIRE_DB_OWNER" \
     -v ldap_baseDN="$LDAP_BASE_DN" \
     -v xmpp_domain="$XMPP_DOMAIN" \
     -v admin_authorized_jid="${OPENFIRE_ADMIN}@${XMPP_DOMAIN}" \
     -f docker-entrypoint-initdb.d/sql/openfire.sql
