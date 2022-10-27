# Docker Image for GeoDjango

 - Available on docker hub: https://hub.docker.com/r/zostera/django-ci/
 - Based on: https://hub.docker.com/r/wooyek/geodjango/ (Thanks!)

License: MIT


## Build and upload

```
(sudo) docker build -t zostera/django-ci .
...
...
Successfully built 5150f0103068

(sudo) docker push zostera/django-ci
```

## Notes about local setup and testing

### On mac OS

```
brew cask install docker # then in apps click on docker app to get in running (whale icon in top bar)

# build image
docker build -t zostera/django-ci .

# run image in container and run django-entrypoint.sh + bash command to open bash prompt
docker run -it zostera/django-ci bash

# stop container
docker container stop <container-id>
```

## Running the tests on a container:

```
# Build image:
docker build -t zostera/django-ci .

# Run tox in the container:
# (current directory is a checkout of https://github.com/observation/observation.org)
docker run --mount type=bind,source=${PWD},target=/github/workspace --workdir=/github/workspace -it zostera/django-ci tox -e django
```