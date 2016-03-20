
FROM alpine:edge

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.1.2"

EXPOSE 8080

ENV APACHE_MIRROR=mirror.synyx.de
ENV TOMCAT_VERSION=8.0.32

ENV CATALINA_HOME=/opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin
ENV JOLOKIA_VERSION=1.3.3

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  apk --quiet update && \
  apk --quiet upgrade

RUN \
  rm -Rf /var/run && \
  ln -s /run /var/run

RUN \
  apk --quiet add \
    curl \
    ca-certificates \
    openjdk8-jre-base && \
  mkdir /opt && \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  "http://${APACHE_MIRROR}/apache/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    | gunzip \
    | tar x -C /opt/ && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm -rf ${CATALINA_HOME}/webapps/* && \
    rm -rf ${CATALINA_HOME}/webapps/examples && \
    rm -rf ${CATALINA_HOME}/webapps/docs && \
    rm -rf ${CATALINA_HOME}/webapps/ROOT && \
    rm -rf ${CATALINA_HOME}/webapps/host-manager && \
    rm -rf ${CATALINA_HOME}/webapps/manager

RUN \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  https://repo1.maven.org/maven2/org/jolokia/jolokia-war/${JOLOKIA_VERSION}/jolokia-war-${JOLOKIA_VERSION}.war > ${CATALINA_HOME}/webapps/jolokia.war

RUN \
  apk del --purge \
    curl \
    wget && \
  rm -rf /src/* /tmp/* /var/cache/apk/*

ADD rootfs/opt/startup.sh /opt/startup.sh

ENTRYPOINT [ "/opt/startup.sh" ]
