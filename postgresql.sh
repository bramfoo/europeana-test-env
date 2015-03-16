#!/usr/bin/env bash

# Versions
export POSTGRES_VERSION="9.3"
export POSTGRES_PASSWORD="vagrant"

# PostgreSQL
# Taken from: http://wiki.postgresql.org/wiki/Apt
# Taken from: https://github.com/fideloper/Vaprobash/blob/master/scripts/pgsql.sh
# Taken from: https://github.com/jackdb/pg-app-dev-vm
echo "[databases] Setting up PostgreSQL..."

# Install PostgreSQL
# -qq implies -y --force-yes
sudo apt-get install -qq postgresql-${POSTGRES_VERSION} postgresql-contrib-${POSTGRES_VERSION}

# Configure PostgreSQL
# Allow login from outside the localhost
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf

# Change settings for password/passwordless logins
# Replace 'local all postgres peer' with 'local all postgres trust' to avoid password
sudo sed -inE 's/\(local[[:space:]]*all[[:space:]]*postgres[[:space:]]*\)\(peer\)/\1trust/' /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf
# Replace 'local all all peer' with 'local all all md5'
sudo sed -inE 's/\(local[[:space:]]*all[[:space:]]*all[[:space:]]*\)\(peer\)/\1md5/' /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf
# Replace 'host all all 127.0.0.1/32 md5' with 'host all all 0.0.0.0/0 md5'
sudo sed -inE 's/\(host[[:space:]]*all[[:space:]]*all[[:space:]]*\)127.0.0.1\/32\([[:space:]]*md5\)/\10.0.0.0\/0\2/' /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf

# Make sure changes are reflected by restarting
sudo service postgresql restart

# Set up basic europeana database
sudo -u postgres psql -c "CREATE USER europeana WITH PASSWORD 'culture';"
sudo -u postgres psql -c "CREATE DATABASE europeana OWNER europeana;"
sudo -u postgres psql -U postgres -d europeana < /vagrant/europeana.sql > /dev/null