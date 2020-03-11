CREATE USER :openfire_db_owner WITH PASSWORD :'openfire_db_password';
CREATE DATABASE :openfire_db OWNER :openfire_db_owner;
GRANT ALL PRIVILEGES ON DATABASE :openfire_db TO :openfire_db_owner;
