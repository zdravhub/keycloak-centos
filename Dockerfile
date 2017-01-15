FROM valerianomanassero/java-centos:latest

MAINTAINER zdravko@octoon.net <zdravko@octoon.net>

RUN yum install -y net-tools vim wget git tar

WORKDIR /opt
RUN wget https://downloads.jboss.org/keycloak/1.9.1.Final/keycloak-1.9.1.Final.tar.gz
RUN tar xvfp keycloak-1.9.1.Final.tar.gz
RUN rm keycloak-1.9.1.Final.tar.gz
RUN cd /opt/keycloak-1.9.1.Final/bin/

RUN ./add-user.sh -u admin -p password

RUN cp -a add-user.sh add-user-wildfly.sh
RUN sed -i 's/org.keycloak.keycloak-wildfly-adduser/org.jboss.as.domain-add-user/g' add-user-wildfly.sh
RUN ./add-user-wildfly.sh -u admin -p password

EXPOSE 8080 9990

CMD ["/opt/keycloak-1.9.1.Final/bin/standalone.sh","-b","0.0.0.0","-bmanagement","0.0.0.0"]
