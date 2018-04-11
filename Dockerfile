
FROM alpine:3.7

EXPOSE 8080 22222

ENV \
  TERM=xterm \
  BUILD_DATE="2018-03-13" \
  APACHE_MIRROR=archive.apache.org \
  TOMCAT_VERSION="9.0.6" \
  CATALINA_HOME=/opt/tomcat \
  JOLOKIA_VERSION="1.5.0" \
  OPENJDK_VERSION="8.151.12" \
  JAVA_HOME=/usr/lib/jvm/default-jvm \
  PATH=${PATH}:/opt/jdk/bin:${CATALINA_HOME}/bin \
  LANG=C.UTF-8

LABEL \
  version="1803" \
  maintainer="Bodo Schulz <bodo@boone-schulz.de>" \
  org.label-schema.build-date=${BUILD_DATE} \
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
  apk update --quiet --no-cache && \
  apk upgrade --quiet --no-cache && \
  apk add --quiet --no-cache \
    curl \
    openjdk8-jre-base && \
  echo "export LANG=${LANG}" > /etc/profile.d/locale.sh && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  sed -i 's,#networkaddress.cache.ttl=-1,networkaddress.cache.ttl=30,' ${JAVA_HOME}/jre/lib/security/java.security && \
  mkdir /opt && \
  echo "download tomcat version ${TOMCAT_VERSION} (https://${APACHE_MIRROR}/apache/tomcat/tomcat-9)" && \
  curl \
    --silent \
    --location \
    --retry 3 \
    --cacert /etc/ssl/certs/ca-certificates.crt \
    "https://${APACHE_MIRROR}/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    | gunzip \
    | tar x -C /opt/ && \
  ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
  ln -s ${CATALINA_HOME}/logs /var/log/jolokia && \
  rm -rf ${CATALINA_HOME}/webapps/* && \
  echo "download jolokia version ${JOLOKIA_VERSION} (https://repo1.maven.org/maven2/org/jolokia/jolokia-war)" && \
  curl \
    --silent \
    --location \
    --retry 3 \
    --cacert /etc/ssl/certs/ca-certificates.crt \
    --output ${CATALINA_HOME}/webapps/jolokia.war \
  https://repo1.maven.org/maven2/org/jolokia/jolokia-war/${JOLOKIA_VERSION}/jolokia-war-${JOLOKIA_VERSION}.war && \
  rm -f ${CATALINA_HOME}/LICENSE && \
  rm -f ${CATALINA_HOME}/NOTICE && \
  rm -f ${CATALINA_HOME}/RELEASE-NOTES && \
  rm -f ${CATALINA_HOME}/RUNNING.txt && \
  rm -f ${CATALINA_HOME}/bin/*.bat && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

HEALTHCHECK \
  --interval=5s \
  --timeout=2s \
  --retries=12 \
  CMD curl --silent --fail http://localhost:8080/jolokia || exit 1

CMD [ "/init/run.sh" ]

# ---------------------------------------------------------------------------------------------------------------------
