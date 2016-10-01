FROM bodsch/docker-alpine-base:1610-01

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.4.1"

EXPOSE 8080

ENV \
  APACHE_MIRROR=mirror.synyx.de \
  TOMCAT_VERSION=8.5.5 \
  CATALINA_HOME=/opt/tomcat \
  JOLOKIA_VERSION=1.3.3 \
  PATH=${PATH}:${CATALINA_HOME}/bin

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache upgrade && \
  apk --quiet --no-cache add \
    openjdk8-jre-base && \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  "http://${APACHE_MIRROR}/apache/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    | gunzip \
    | tar x -C /opt/ && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    ln -s ${CATALINA_HOME}/logs /var/log/jolokia && \
    rm -rf ${CATALINA_HOME}/webapps/* && \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  https://repo1.maven.org/maven2/org/jolokia/jolokia-war/${JOLOKIA_VERSION}/jolokia-war-${JOLOKIA_VERSION}.war > ${CATALINA_HOME}/webapps/jolokia.war && \
  apk del --quiet --purge \
    curl \
    wget && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

# ADD rootfs/opt/startup.sh /opt/startup.sh

# CMD [ '/bin/sh' ]
CMD [ "/opt/startup.sh" ]

