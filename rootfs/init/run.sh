#!/bin/sh

if [ ${DEBUG} ]
then

  file="/opt/tomcat/conf/Catalina/localhost/jolokia.xml"

  cat << EOF > ${file}
<!-- see https://jolokia.org/reference/html/agents.html#war-agent-installation for full examples -->
<Context>
  <Parameter name="debug" value="true"/>
</Context>

EOF

fi

if [ -d /init/custom.d ]
then
  for f in /init/custom.d/*
  do
    case "$f" in
      *.sh)     echo "$0: running $f"; . "$f" ;;
      *)        echo "$0: ignoring $f" ;;
    esac
    echo
  done
fi

set +x

# set pid file
CATALINA_PID="${CATALINA_HOME}/temp/catalina.pid"
# set memory settings
# export JAVA_OPTS="-Xmx256M ${JAVA_OPTS}"
# https://github.com/rhuss/jolokia/issues/222#issuecomment-170830887
# 30s timeout
CATALINA_OPTS="${CATALINA_OPTS} -Xms256M"
CATALINA_OPTS="${CATALINA_OPTS} -Xmx1025m"
CATALINA_OPTS="${CATALINA_OPTS} -XX:NewSize=256m"
CATALINA_OPTS="${CATALINA_OPTS} -XX:MaxNewSize=256m"
CATALINA_OPTS="${CATALINA_OPTS} -XX:PermSize=256m"
CATALINA_OPTS="${CATALINA_OPTS} -XX:MaxPermSize=256m"
CATALINA_OPTS="${CATALINA_OPTS} -XX:+DisableExplicitGC"
CATALINA_OPTS="${CATALINA_OPTS} -XX:HeapDumpPath=/var/logs/"
CATALINA_OPTS="${CATALINA_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseConcMarkSweepGC"
CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseParNewGC"
CATALINA_OPTS="${CATALINA_OPTS} -XX:SurvivorRatio=8"
CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseCompressedOops"
CATALINA_OPTS="${CATALINA_OPTS} -Dserver.name=${HOSTNAME}"
CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.port=22222"
CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="${CATALINA_OPTS} -Dsun.rmi.transport.tcp.responseTimeout=30000"

export CATALINA_PID
export JAVA_OPTS
export CATALINA_OPTS


/bin/sh -e /opt/tomcat/bin/catalina.sh run

# EOF
