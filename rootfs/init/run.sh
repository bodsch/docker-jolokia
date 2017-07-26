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

export CATALINA_PID="${CATALINA_HOME}/temp/catalina.pid"
export JAVA_OPTS="-Xmx256M ${JAVA_OPTS}"

/bin/sh -e /opt/tomcat/bin/catalina.sh run

# EOF
