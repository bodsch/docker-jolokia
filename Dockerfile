
FROM bodsch/docker-openjdk-8:1702-02

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.6.0"

EXPOSE 8080

ENV \
  APACHE_MIRROR=mirror.synyx.de \
  TOMCAT_VERSION=8.5.11 \
  CATALINA_HOME=/opt/tomcat \
  JOLOKIA_VERSION=1.3.5 \
  PATH=${PATH}:${CATALINA_HOME}/bin

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    curl && \
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
    ln -s ${CATALINA_HOME}/logs /var/log/jolokia && \
    rm -rf ${CATALINA_HOME}/webapps/* && \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  --output ${CATALINA_HOME}/webapps/jolokia.war \
  https://repo1.maven.org/maven2/org/jolokia/jolokia-war/${JOLOKIA_VERSION}/jolokia-war-${JOLOKIA_VERSION}.war && \
  apk del --quiet --purge \
    bash \
    nano \
    tree \
    curl \
    ca-certificates \
    supervisor && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------------------------------------
