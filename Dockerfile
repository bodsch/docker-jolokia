
FROM bodsch/docker-openjdk-8:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1705-01"

EXPOSE 8080

ENV \
  TERM=xterm \
  BUILD_DATE="2017-05-01" \
  APACHE_MIRROR=mirror.synyx.de \
  TOMCAT_VERSION=8.5.14 \
  CATALINA_HOME=/opt/tomcat \
  JOLOKIA_VERSION=1.3.6 \
  PATH=${PATH}:${CATALINA_HOME}/bin

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="Jolokia Docker Image" \
      org.label-schema.description="Inofficial Jolokia Docker Image" \
      org.label-schema.url="https://jolokia.org" \
      org.label-schema.vcs-url="https://github.com/bodsch/docker-jolokia" \
      org.label-schema.vendor="Bodo Schulz" \
      org.label-schema.version=${JOLOKIA_VERSION} \
      org.label-schema.schema-version="1.0" \
      com.microscaling.docker.dockerfile="/Dockerfile" \
      com.microscaling.license="GNU General Public License v3.0"

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache upgrade && \
  apk --verbose --no-cache add  --virtual build-deps \
    curl && \
  mkdir /opt && \
  curl \
    --silent \
    --location \
    --retry 3 \
    --cacert /etc/ssl/certs/ca-certificates.crt \
    "https://${APACHE_MIRROR}/apache/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
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
  apk --purge del \
    build-deps && \
  rm -f ${CATALINA_HOME}/LICENSE && \
  rm -f ${CATALINA_HOME}/NOTICE && \
  rm -f ${CATALINA_HOME}/RELEASE-NOTES && \
  rm -f ${CATALINA_HOME}/RUNNING.txt && \
  rm -f ${CATALINA_HOME}/bin/*.bat && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

CMD [ "/init/run.sh" ]

# ---------------------------------------------------------------------------------------------------------------------
