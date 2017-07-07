#
# Dockerfile - Spacewalk
#


# 1. Base images
FROM     centos:6
MAINTAINER Jeremie CUADRADO <redbeard28>

# 2. Set the environment variable
ARG HTTP_PROXY
ARG HTTPS_PROXY
WORKDIR /opt
ENV SPACEWALKVERSION=2.6
ENV VERSION=2.6-0
ENV REALSERVER=6
ENV BASEARCH=x86_64

# 3. Add the epel, spacewalk, jpackage repository, supervisord
ADD conf/jpackage.repo /etc/yum.repos.d/jpackage.repo
RUN yum install -y epel-release \
 && yum install -y http://spacewalk.redhat.com/yum/$SPACEWALKVERSION/RHEL/6/$BASEARCH/spacewalk-repo-$VERSION.el$REALSERVER.noarch.rpm \
 && yum check-update ; yum upgrade -y \
 && yum install -y spacewalk-setup-postgresql spacewalk-postgresql tomcat-native python-setuptools \
 && yum clean all \
 && easy_install pip && pip install supervisor && pip install --upgrade meld3==0.6.10 && mkdir /etc/supervisord.d \
 && rm -rf /root/.cache


# 4. Install supervisord config
ADD conf/supervisord.conf /etc/supervisord.d/supervisord.conf

# 5. Install spacewalk initial and running scripts
ADD conf/answer.txt   /opt/answer.txt
ADD conf/spacewalk.sh /opt/spacewalk.sh

# 6. Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.d/supervisord.conf"]

# System Log
VOLUME /var/log

# PostgreSQL Data
VOLUME /var/lib/pgsql/data

# RPM repository
VOLUME /var/satellite

# Bootstrap directory
VOLUME /var/www/html/pub

# Port
EXPOSE 80 443 522 68 69
