#!/usr/bin/env bash

/etc/init.d/memcached start
/etc/init.d/redis-server start
/etc/init.d/postgresql start

echo "*** Setting up Postgres database ***"
# Enable postgis for all new databases (http://stackoverflow.com/a/35209186/260480)
sudo -u postgres -E psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Create primary and test databases
echo "Creating user ${DB_USER}"
sudo -u postgres -E sh -c 'createuser -s ${DB_USER}'
sudo -u postgres -E psql -c "ALTER USER \"${DB_USER}\" PASSWORD '${DB_PASSWORD}';"

echo "*** Running command passed down to docker ***"
exec "$@"
