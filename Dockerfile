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
RUN echo '<?xml version="1.0" ?>' > /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '<module xmlns="urn:jboss:module:1.1" name="org.postgresql">' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '<resources>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '<resource-root path="postgresql-9.4.1212.jar"/>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '</resources>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '<dependencies>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '<module name="javax.api"/>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '<module name="javax.transaction.api"/>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '</dependencies>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml
RUN echo '</module>' >> /opt/wildfly-10.0.0.Final/modules/org/postgresql/main/module.xml

RUN /opt/wildfly-10.0.0.Final/bin/add-user.sh -u admin -p password

# RUN cp -a /opt/wildfly-10.0.0.Final/bin/add-user.sh /opt/wildfly-10.0.0.Final/bin/add-user-wildfly.sh
# RUN sed -i 's/org.keycloak.keycloak-wildfly-adduser/org.jboss.as.domain-add-user/g' /opt/wildfly-10.0.0.Final/bin/add-user-wildfly.sh
# RUN /opt/wildfly-10.0.0.Final/bin/add-user-wildfly.sh -u admin -p password

EXPOSE 8080 9990

CMD ["/opt/wildfly-10.0.0.Final/bin/standalone.sh","-c","standalone-full-ha.xml","-b","0.0.0.0","-bmanagement","0.0.0.0"]
