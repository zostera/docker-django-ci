# Docker Image for GeoDjango

 - Available on docker hub: https://hub.docker.com/r/zostera/django-ci/
 - Based on: https://hub.docker.com/r/wooyek/geodjango/ (Thanks!)

License: MIT


## Debugging/testing out commands in the container:

```
(sudo) docker build -t test .
...
...
Successfully built 5150f0103068
# run the container, with -i (interactive)
(sudo) docker run -dit test
<container-id>
sudo docker exec -it <container-id> /bin/bash
```
