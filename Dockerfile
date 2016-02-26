FROM alpine:3.3

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.1.0"

EXPOSE 8080

ENV TOMCAT_VERSION 8.0.23
# SET CATALINE_HOME and PATH
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# ---------------------------------------------------------------------------------------------------------------------

RUN \
  apk add --update \
    curl \
    ca-certificates \
    openjdk7-jre && \
  rm -rf /var/cache/apk/* && \
  mkdir /opt && \
  curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  "https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    | gunzip \
    | tar x -C /opt/ && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
    rm -rf /opt/tomcat/webapps/{examples,docs,ROOT} && \
  wget "http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-war/1.3.3/jolokia-war-1.3.3.war" -O /opt/tomcat/webapps/jolokia.war

ADD rootfs/ /

# ADD data/run.sh /usr/local/bin/run.sh
# RUN chmod u+x /usr/local/bin/run.sh

ENTRYPOINT [ "/opt/startup.sh" ]
