FROM centos:centos7

MAINTAINER zdravko@octoon.net <zdravko@octoon.net>

RUN yum install -y wget git tar java-1.8.0-openjdk-headless

ENV JAVA_HOME /usr/lib/jvm/jre

WORKDIR /opt
RUN wget https://downloads.jboss.org/keycloak/1.9.1.Final/keycloak-1.9.1.Final.tar.gz
RUN tar xvfp keycloak-1.9.1.Final.tar.gz
RUN rm keycloak-1.9.1.Final.tar.gz

CMD ["/opt/keycloak-1.9.1.Final/bin/standalone.sh", "-b", "0.0.0.0"]

EXPOSE 8080 9990
