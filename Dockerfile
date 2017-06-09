#
# Dockerfile - Spacewalk
#
# - Build
# git clone https://github.com/redbeard28/docker-spacewalk /opt/docker-spacewalk
# docker build --rm -t spacewalk /opt/docker-spacewalk
#
# - Run
# docker run --privileged=true -d --name="spacewalk" -h "spackewalk" spacewalk

# 1. Base images
FROM     centos:centos7
MAINTAINER Jérémie CUADRADO <redbeard28>

# 2. Set the environment variable
WORKDIR /opt

# 3. Add the epel, spacewalk, jpackage repository
ADD conf/jpackage.repo /etc/yum.repos.d/jpackage.repo
RUN yum install wget -y
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm \
 && rpm -Uvh http://yum.spacewalkproject.org/latest/RHEL/7/x86_64/spacewalk-reports-2.6.3-1.el7.noarch.rpm

# 4. Installation a spacewalk
ADD conf/answer.txt	/opt/answer.txt
ADD conf/spacewalk.sh	/opt/spacewalk.sh
RUN chmod a+x /opt/spacewalk.sh
RUN yum install -y spacewalk-setup-postgresql spacewalk-postgresql

# 5. Supervisor
RUN yum install -y python-setuptools && easy_install pip && pip install supervisor && mkdir /etc/supervisord.d
ADD conf/supervisord.conf /etc/supervisord.d/supervisord.conf

# 6. Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.d/supervisord.conf"]

# Port
EXPOSE 80 443

# Run docker behind a proxy !
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