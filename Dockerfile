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
ENV http_proxy "http://X.X.X.X:3128"
ENV https_proxy "http://X.X.X.X:3128"
ADD conf/jpackage.repo /etc/yum.repos.d/jpackage.repo
RUN yum clean all
RUN yum install wget net-tools curl -y
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
RUN awk '!/mirrorlist/' /etc/yum.repos.d/epel.repo > /tmp/toto && mv -f /tmp/toto /etc/yum.repos.d/epel.repo
RUN awk '!/mirrorlist/' /etc/yum.repos.d/CentOS-Base.repo > /tmp/titi && mv -f /tmp/titi /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i "s/\#baseurl/baseurl/g" /etc/yum.repos.d/epel.repo
RUN sed -i "s/\#baseurl/baseurl/g" /etc/yum.repos.d/CentOS-Base.repo
RUN rpm -Uvh http://yum.spacewalkproject.org/2.3/RHEL/7/x86_64/spacewalk-repo-2.3-4.el7.noarch.rpm
RUN yum update -y

# 4. Installation a spacewalk
ADD conf/answer.txt     /opt/answer.txt
ADD conf/spacewalk.sh   /opt/spacewalk.sh
RUN chmod a+x /opt/spacewalk.sh
RUN yum install -y spacewalk-setup-postgresql spacewalk-postgresql

# 5. Supervisor
RUN yum install -y python-setuptools && easy_install pip && pip install supervisor && mkdir /etc/supervisord.d
ADD conf/supervisord.conf /etc/supervisord.d/supervisord.conf

# 6. Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.d/supervisord.conf"]

# Port
EXPOSE 80 443
