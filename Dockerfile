#
# Dockerfile - Spacewalk
#
# ORIGINAL SOURCES FROM Eduardo Gonzalez Gutierrez <dabarren@gmail.com>
#
# - Build
# git clone https://github.com/redbeard28/docker-spacewalk /opt/docker-spacewalk
# docker build --rm -t spacewalk /opt/docker-spacewalk
#
# - Run
# docker run --privileged=true -d --name="spacewalk" -h "spackewalk" spacewalk

# 1. Base images
FROM     centos:7
MAINTAINER Jérémie CUADRADO <redbeard28>

# 2. Set the environment variable
#WORKDIR /opt
ENV http_proxy "http://X.X.X.X:3128"
ENV https_proxy "http://X.X.X.X:3128"

# 3. Add the epel, spacewalk, jpackage repository
ADD conf/jpackage.repo /etc/yum.repos.d/jpackage.repo

RUN yum clean all
RUN yum install -y http://yum.spacewalkproject.org/2.5/RHEL/7/x86_64/spacewalk-repo-2.5-3.el7.noarch.rpm \
        epel-release && \
        yum clean all

RUN rpm --import http://www.jpackage.org/jpackage.asc && \
    rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && \
    rpm --import http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2015 && \
    yum clean all

RUN yum -y install \
        spacewalk-setup-postgresql \
        spacewalk-postgresql \
        supervisor  \
        yum clean all

COPY conf/answer.txt /tmp/answer.txt

EXPOSE 80 443 5222 68 69

USER postgres
RUN /usr/bin/pg_ctl initdb  -D /var/lib/pgsql/data/
RUN /usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300 && \
     psql -c 'CREATE DATABASE spaceschema' && \
     psql -c "CREATE USER spaceuser WITH PASSWORD 'spacepw'" && \
     psql -c 'ALTER ROLE spaceuser SUPERUSER' && \
     createlang pltclu spaceschema

USER root

RUN su -c "/usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300" postgres && \
    su -c "spacewalk-setup --answer-file=/tmp/answer.txt --skip-db-diskspace-check --skip-db-install" root ; exit 0

ADD supervisord.conf /etc/supervisord.d/supervisord.conf

ENTRYPOINT supervisord -c /etc/supervisord.d/supervisord.conf

# USE BEHING A DIRT PROXY!
#RUN awk '!/mirrorlist/' /etc/yum.repos.d/epel.repo > /tmp/toto && mv -f /tmp/toto /etc/yum.repos.d/epel.repo
#RUN awk '!/mirrorlist/' /etc/yum.repos.d/CentOS-Base.repo > /tmp/titi && mv -f /tmp/titi /etc/yum.repos.d/CentOS-Base.repo
#RUN sed -i "s/\#baseurl/baseurl/g" /etc/yum.repos.d/epel.repo
#RUN sed -i "s/\#baseurl/baseurl/g" /etc/yum.repos.d/CentOS-Base.repo
