#!/bin/bash

export ENCRYPTED_USERNAME=`perl encoder.pl ${OPENFIRE_DB_OWNER}`
export ENCRYPTED_PASSWORD=`perl encoder.pl ${OPENFIRE_DB_PASSWORD}`
envsubst </opt/openfire/conf/openfire-template.xml >/opt/openfire/conf/openfire.xml

if [ "$( psql -h db -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${OPENFIRE_DB}';" )" = '1' ]; then
    /opt/openfire/bin/openfire run
fi

