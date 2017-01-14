FROM valerianomanassero/java-centos:latest

MAINTAINER zdravko@octoon.net <zdravko@octoon.net>

RUN yum install -y net-tools openssh-server vim wget git tar

WORKDIR /opt
RUN wget https://downloads.jboss.org/keycloak/1.9.1.Final/keycloak-1.9.1.Final.tar.gz
RUN tar xvfp keycloak-1.9.1.Final.tar.gz
RUN rm keycloak-1.9.1.Final.tar.gz

EXPOSE 22 8080 9990

CMD /usr/sbin/sshd -D
CMD ["/opt/keycloak-1.9.1.Final/bin/standalone.sh", "-b", "0.0.0.0"]
