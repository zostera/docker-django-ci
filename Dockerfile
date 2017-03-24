FROM ubuntu:16.04

MAINTAINER Zostera B.V.
LABEL version="0.1.0"
# Based on work by Janusz Skonieczny @wooyek

# Install tooling for test debuging and libraries needed by geodjango.
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y git unzip nano wget sudo curl build-essential \
    python python-dev python-pip python-virtualenv \
    python3 python3-dev python3-pip python3-venv \
    spatialite-bin libsqlite3-mod-spatialite \
    postgresql-client-common libpq-dev \
    postgresql postgresql-contrib postgis \
    libmemcached11 libmemcachedutil2 libmemcached-dev libz-dev \
    libproj-dev libfreexl-dev libgdal-dev gdal-bin && \
    python -m pip install pip -U && \
    python3 -m pip install pip -U && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip install invoke pathlib tox coverage pylint -U && \
    pip3 install invoke tox coverage pylint -U

ENV PYTHONIOENCODING=utf-8

# Pass this envrioment variables through a file
# https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file
# They will be used to create a default database on start

ENV DB_NAME=application-db \
    DB_PASSWORD=application-db-password \
    DB_USER=application-user-user \
    DB_HOST=127.0.0.1 \
    DB_TEST_NAME=application-test-db

COPY django-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/django-entrypoint.sh
ENTRYPOINT ["django-entrypoint.sh"]
