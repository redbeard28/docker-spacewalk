<h1>
  <span>Dockerfile - Spacewalk</span>
  <a href='http://docker-spacewalk.rtfd.io/en/latest/?badge=latest'>
    <img src='https://readthedocs.org/projects/docker-spacewalk/badge/?version=latest' alt='Documentation Status' />
  </a>
</h1>

https://readthedocs.org/projects/docker-spacewalk/badge/?version=latest

Dockerfile - Spacewalk
======================

# What Can I do?
Here you can chose between two methodes:
 1. Build/Install manualy the docker container - use folder conf
 2. Use the Ansible role in folder roles

# Methode 1 - Manualy Build
## Build
```
root@redbeard28:~# git clone https://github.com/redbeard28/docker-spacewalk.git /opt/dredbeard28-spacewalk
root@redbeard28:~# docker build --rm -t redbeard28/spacewalk .
```

## Run
```
root@redbeard28:~# docker run --privileged=true -d --name="spacewalk" -p 80:80 \
  -p 443:443 -p 5222:5222 -p 68:68 -p 69:69 -v /opt/container/spacewalk/satellite:/var/satellite \
  -v /opt/container/spacewalk/log:/var/log -v /opt/container/spacewalk/lib/pgsql:/var/lib/pgsql \
  -v /opt/container/spacewalk/var/www/html/pub:/var/www/html/pub redbeard28/spacewalk
```
```
root@redbeard28:~# docker inspect -f '{{ .NetworkSettings.IPAddress }}' spacewalk
172.16.1.40
```


### Run docker behind a proxy !
Source documentation from docker website...

First, create a systemd drop-in directory for the docker service:
```bash
mkdir /etc/systemd/system/docker.service.d
```

Now create a file called /etc/systemd/system/docker.service.d/http-proxy.conf that adds the HTTP_PROXY environment variable:
```bash
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
```

For HTTPS create a file called /etc/systemd/system/docker.service.d/https-proxy.conf that adds the HTTPS_PROXY environment variable:
```bash
[Service]
Environment="HTTPS_PROXY=http://proxy.example.com:80/"
```

If you have internal Docker registries that you need to contact without proxying you can specify them via the NO_PROXY environment variable:
/etc/systemd/system/docker.service.d/no-proxy.conf
```bash
[Service]
Environment="NO_PROXY=localhost,127.0.0.0/8,10.20.*,docker-registry.somecorporation.com"
```

Flush changes:
```bash
$ sudo systemctl daemon-reload
```

Verify that the configuration has been loaded:
```bash
$ sudo systemctl show --property Environment docker
Environment=HTTP_PROXY=http://proxy.example.com:80/
```

Restart Docker:
```bash
$ sudo systemctl restart docker
```

### Run docker **container** behind a proxy !
Put an ENV in the Dockerfile

```bash
ARG HTTP_PROXY
ARG HTTPS_PROXY
```

In my case I prefert to user variable
```bash
docker  build --build-arg HTTP_PROXY="http://X.X.X.X:8080" -build-arg HTTPS_PROXY=http://X.X.X.X:8080 --rm -t spacewalk .
```

## Methode 2: From Ansible role

Run this cmd:
```bash
ansible-playbook -i "localhost," -c local spacewalk.yml -e site=jcu # CHANGE IT !
```


# Original credits
This work is based on bashell container
https://hub.docker.com/r/bashell/spacewalk/