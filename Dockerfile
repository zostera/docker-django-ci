FROM ubuntu:focal-20221019

LABEL version="0.3.5" org.opencontainers.image.authors="Zostera B.V."
# Based on work by Janusz Skonieczny @wooyek

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y software-properties-common

# PostgreSQL apt server for newer PostgreSQL and PostGIS versions
RUN APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main"

# deadsnakes ppa for modern python versions
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update

RUN apt-get install -y git unzip wget sudo curl build-essential gettext \
    postgresql-client-common libpq-dev \
    postgresql-12 postgresql-12-postgis-3 \
    libmemcached11 libmemcachedutil2 libmemcached-dev libz-dev memcached \
    libproj-dev libfreexl-dev libgdal-dev gdal-bin \
    ffmpeg

# Various python versions
RUN apt-get install -y python3 python3-pip \
    python3.8 python3.8-dev \
    python3.9 python3.9-dev \
    python3.10 python3.10-dev \
    python3.11 python3.11-dev

# install recent version of nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get -y install nodejs libxcb-dri3-0 libxss1 libdrm2 libgbm1

# install the redis server, bind to ipv4 (or it will not start)
RUN apt-get -y install redis-server && \
    sed -i "s/^bind 127.0.0.1.*/bind 127.0.0.1/g" /etc/redis/redis.conf

# install firefox and geckodriver needed for selenium tests
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz && \
    tar -xvzf geckodriver-v0.24.0-linux64.tar.gz && \
    mv geckodriver /usr/local/bin && \
    rm -f geckodriver-v0.24.0-linux64.tar.gz && \
    sudo apt-get -y install firefox

RUN python3 -m pip install pip -U && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    python3 -m pip install -U tox setuptools

ENV PYTHONIOENCODING=utf-8
ENV LANG=en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Pass this environment variables through a file
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
