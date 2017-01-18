FROM valerianomanassero/java-centos:latest

MAINTAINER zdravko@octoon.net <zdravko@octoon.net>

RUN yum install -y net-tools vim wget git tar

WORKDIR /opt

RUN wget http://download.jboss.org/wildfly/10.0.0.Final/wildfly-10.0.0.Final.tar.gz
RUN wget http://downloads.jboss.org/keycloak/1.9.1.Final/keycloak-overlay-1.9.1.Final.tar.gz

RUN tar xvfp wildfly-10.0.0.Final.tar.gz
RUN rm wildfly-10.0.0.Final.tar.gz

RUN mv /opt/keycloak-overlay-1.9.1.Final.tar.gz /opt/wildfly-10.0.0.Final/
RUN cd /opt/wildfly-10.0.0.Final && tar xvfp keycloak-overlay-1.9.1.Final.tar.gz && rm keycloak-overlay-1.9.1.Final.tar.gz

RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar
RUN mkdir -p /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/
RUN mv /opt/postgresql-9.4.1212.jar /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/

ADD modules/org/postgresql/main/module.xml /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/
ADD standalone/configuration/standalone-full-ha.xml /opt/wildfly-10.0.0.Final/standalone/configuration/standalone-full-ha.xml

RUN /opt/wildfly-10.0.0.Final/bin/add-user.sh -u admin -p password

RUN cp -a /opt/wildfly-10.0.0.Final/bin/add-user.sh /opt/wildfly-10.0.0.Final/bin/add-user-keycloak.sh
RUN sed -i 's/org.jboss.as.domain-add-user/org.keycloak.keycloak-wildfly-adduser/g' /opt/wildfly-10.0.0.Final/bin/add-user-keycloak.sh
RUN /opt/wildfly-10.0.0.Final/bin/add-user-keycloak.sh -u admin -p password

COPY docker-entrypoint.sh /

EXPOSE 8080 9990
ENTRYPOINT ["/docker-entrypoint.sh"]
