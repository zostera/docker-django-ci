FROM ubuntu:focal

LABEL version="0.3.6" org.opencontainers.image.authors="Zostera B.V."
# Based on work by Janusz Skonieczny @wooyek

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y software-properties-common

RUN set -e \
    && apt-get update -y \
    && apt-get install -y curl gnupg ca-certificates software-properties-common build-essential git netcat \
    && add-apt-repository ppa:deadsnakes/ppa \
    # Add nodesource to install a recent version of nodejs
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    # Add PostgreSQL repository
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && apt-get update -y \
    && apt-get install -y nodejs \
    gettext binutils libproj-dev gdal-bin libgdal-dev \
    python3.11 python3.11-dev python3.11-distutils python3.11-venv \
    python3.12 python3.12-dev python3.12-venv \
    exif ffmpeg libmemcached11 libmemcachedutil2 libmemcached-dev libz-dev \
    libpq-dev gettext sassc libfreetype6 libfreetype6-dev postgresql-client-15 \
    redis-server \
    && rm -rf /var/lib/apt/lists/* \
    # Make the python executable work for django commands that use `/usr/bin/env python`
    && ln -s /usr/bin/python3.11 /usr/local/bin/python \
    && ln -s /usr/bin/python3.11 /usr/local/bin/python3 \
    && git config --global --add safe.directory /home/app \
    # Bind the redis server to ipv4 (or it will not start)
    && sed -i "s/^bind 127.0.0.1.*/bind 127.0.0.1/g" /etc/redis/redis.conf

RUN python3.11 -m ensurepip && python3.11 -m pip install --upgrade pip

# Silence warnings like 'fatal: detected dubious ownership in repository at '/github/workspace'
RUN git config --system --add safe.directory '*' && \
    git config --system status.hints false &

ENV PYTHONIOENCODING=utf-8
ENV LANG=en_US.UTF-8

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
