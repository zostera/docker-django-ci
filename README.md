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
brew cask install docker

docker build -t zostera/django-ci .

docker run -dit zostera/django-ci

docker container ls  # to see temp_name_container

docker exec -it temp_name_container bash
```