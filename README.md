**Openfire Server using Docker Compose**
Latest release: 0.1.0 - Openfire v4.4.2 - [Docker Hub] (https://) 
## Quick Start
If you want to run the Openfire Server you will need to have Docker and Docker Compose intalled in tyour system.
```shell
joaquin@DustInTheWind $ docker --version
Docker version 19.03.6, build 369ce74a3c
joaquin@DustInTheWind $ docker-compose --version
docker-compose version 1.25.1, build a82fef07
```
Clone the proyect somewhere in your local drive and start the system by running: 
```shell
joaquin@DustInTheWind $ git clone ....
joaquin@DustInTheWind $ cd openfire
joaquin@DustInTheWind $ docker-compose up  --detach --build
docker-compose up --detach --build
Creating network "openfire_default" with the default driver
Building db
Step 1/9 : FROM postgres:12.1
---> ec5d6d5f5b34
...
Successfully built 2749f1a1cb49
Successfully tagged db_openfire:0.1.0
Building ldap
Step 1/7 : FROM osixia/openldap:latest
...
Successfully built 73ee92c3c2c5
Successfully tagged ldap_openfire:0.1.0
Building openfire
Step 1/11 : FROM ubuntu:bionic
...
Successfully built a0c320a1433c
Successfully tagged openfire:0.1.0
Creating openfire_db_1             ... done
Creating openfire_ldap_1 ... done
Creating openfire_php-ldap-admin_1 ... done
Creating openfire_openfire_1       ... done
```
You can access the administartion console for Openfire using your web browser: 

    http://localhost:9090

The required credential are:

|username | of_admin      |
|password | of_admin_pass |


Then you can use phpLDAPadmin to administer your OpenLDAP server by pointing your browser to:

    https://localhost:6443/

The credentials to connect ti the server are:

|Login DN | cn=admin,dc=example,dc=com|
|Password | ldap_admin_pass           |


## Introduction 

Openfire is an instant messaging and group chat server for the Extensible Messaging and Presence Protocol (XMPP) developed by Ignite Realtime. It's licensed under the Apache License 2.0. 

Futher details about Openfire can be found in https://www.igniterealtime.org/projects/openfire.

## Architecture 

Most of the Docker solutions for Openfire are build as a single image using the embeded HSQLDB database management system. This solution is based in four services.

* db: database service using PostgreSQL 
* ldap: a service to manage users and groups base on OpenLDAP.
* php-ldap-admin: a service providing a graphical interface to manage the ldap service.
* openfire: the XMPP server based on Openfire.


## Customization 

This is a minimal solution that can easily be customized to cover your needs and environment.

### Enviroment Variables 

The easiest way to customize is the use of enviroment variables. These variables are included in the __.env__ file.

* __LDAP_ADMIN_PASSWORD__. This is the password to be used when login in the OpenLDAP server as administrator. The delaut value is `ldap_admin_pass`.
* __LDAP_BASE_DN__. This is the point form where the server will start to search for users. The default value is `dc=example,dc=com`.  
* __LDAP_DOMAIN__. The domain on which operate our OpenLDAP server. `example.com`.
* __LDAP_ORGANISATION__. The Organization that is associated to our OpenLDAP server. In our case `Example Inc`. 
* __OPENFIRE_ADMIN__. The username used by the Openfire administrator to long into the console. By default is `of_admin`.
* __OPENFIRE_ADMIN_FULL_NAME__. A string that descriibes the administrator of Openfire. It is used when the administrator is created when the container is created. We use `Openfire Administrator`.
* __OPENFIRE_ADMIN_GROUP__. The Unix group of the Openfire administrator. In our system: `admin_group`. 
* __OPENFIRE_ADMIN_PASSWORD__. This is the password used by the Openfire to log into the Openfire console. See `OPENFIRE_ADMIN` above. The default value is `of_admin_pass`.
* __OPENFIRE_DB__. The name of the PostgreSQL schema that contains the Openfire data. The default value is `of_db`. 
* __OPENFIRE_DB_OWNER__. The PostgreSQL role name who owns the Openfire schema. See the `OPENFIRE_DB`. The default value is `of_db_owner`.
* __OPENFIRE_DB_PASSWORD__. The password of the owner of the Openfire schema in PostgreSQL: `of_db_owner_pass`. 
* __OPENFIRE_SERVER__. The hostanme of the Openfire server.By default: `openfire-server.example.com`.
* __POSTGRES_USER__. The PostgreSQL administrator: `postgres`.
* __POSTGRES_PASSWORD__. The password for the Postgres administrator. The default value is set to: `postgres_pass`.
* __XMPP_DOMAIN__. The domain part of a XMPP service. We use by default `openfire.example.com`.

There are many other enviroment variables that can be used to customize these services. Please check "Basic Images" below for details.

### Openfire Plugins ###

Openfire offers a number of plugins that extends its functionality. This project include some of them. For a list of available plugins visit: https://www.igniterealtime.org/projects/openfire/plugins.jsp. 

To add a new plugin just drop the jar file in the `openfire/plugins folder`.

### Adding Users and Groups ###

The OpenLDAP server includes by default two users. You can more groups and users by dropping ldif files in the `ldif` folder. This folder includes an example of how to add a new user to the same group than the Openfire administrator.

## Basic Images ##

The following base images are used in this project:

* __osixia/openldap:latest__ (https://github.com/osixia/docker-openldap). It uses OPENLDAP 2.4.48
* __osixia/phpldapadmin:latest__ (https://github.com/osixia/phpldapadmin). This image is based on phpLDAPadmin 1.2.5.
* __postgres:12.1__ (https://hub.docker.com/_/postgres)
* __ubuntu:bionic__(https://hub.docker.com/_/ubuntu)