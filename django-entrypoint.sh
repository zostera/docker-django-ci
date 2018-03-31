#!/usr/bin/env bash

# =========================
# Start memcached service
# =========================
/etc/init.d/memcached start

# =========================
# Setup Postgres data base
# =========================
/etc/init.d/postgresql start

echo "*** Report Postgres version ***"
sudo -u postgres --version
sudo -u pg_restore --version

echo "*** Setting up Postgres database ***"
# First you need to enable postgis for all new databases. This will remove superuser requirement during db initialization
# http://stackoverflow.com/a/35209186/260480
sudo -u postgres -E psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Create primary and test databases
echo "Creating user ${DB_USER}"
sudo -u postgres -E sh -c 'createuser -s ${DB_USER}'
sudo -u postgres -E psql -c "ALTER USER \"${DB_USER}\" PASSWORD '${DB_PASSWORD}';"

echo "Creating databases ${DB_NAME} and ${DB_TEST_NAME}"
sudo -u postgres -E sh -c 'createdb ${DB_NAME}'
sudo -u postgres -E sh -c 'createdb ${DB_TEST_NAME}'

echo "*** Running command passed down to docker ***"
exec "$@"
