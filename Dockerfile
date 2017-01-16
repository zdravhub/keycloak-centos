FROM valerianomanassero/java-centos:latest

MAINTAINER zdravko@octoon.net <zdravko@octoon.net>

RUN yum install -y net-tools vim wget git tar

WORKDIR /opt
RUN wget https://downloads.jboss.org/keycloak/1.9.1.Final/keycloak-1.9.1.Final.tar.gz
RUN tar xvfp keycloak-1.9.1.Final.tar.gz
RUN rm keycloak-1.9.1.Final.tar.gz

RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar
RUN mkdir -p /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/
RUN mv /opt/postgresql-9.4.1212.jar /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/
RUN echo '<?xml version="1.0" ?>' > /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '<module xmlns="urn:jboss:module:1.1" name="org.postgresql">' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '<resources>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '<resource-root path="postgresql-9.4.1212.jar"/>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '</resources>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '<dependencies>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '<module name="javax.api"/>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '<module name="javax.transaction.api"/>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '</dependencies>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml
RUN echo '</module>' >> /opt/keycloak-1.9.1.Final/modules/org/postgresql/main/module.xml

RUN /opt/keycloak-1.9.1.Final/bin/add-user.sh -u admin -p password

RUN cp -a /opt/keycloak-1.9.1.Final/bin/add-user.sh /opt/keycloak-1.9.1.Final/bin/add-user-wildfly.sh
RUN sed -i 's/org.keycloak.keycloak-wildfly-adduser/org.jboss.as.domain-add-user/g' /opt/keycloak-1.9.1.Final/bin/add-user-wildfly.sh

RUN /opt/keycloak-1.9.1.Final/bin/add-user-wildfly.sh -u admin -p password

EXPOSE 8080 9990

CMD ["/opt/keycloak-1.9.1.Final/bin/standalone.sh","-b","0.0.0.0","-bmanagement","0.0.0.0"]
