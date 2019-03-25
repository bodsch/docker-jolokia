#!/bin/sh

curl_opts="--silent --fail"

if [ -f ${CATALINA_HOME}/conf/tomcat-users.xml ]
then
  count=$(grep -c "user username" ${CATALINA_HOME}/conf/tomcat-users.xml)

  if [ ${count} -gt 0 ]
  then
    credentials=$(grep "user username" ${CATALINA_HOME}/conf/tomcat-users.xml | \
      tail -n1 | \
      sed -e 's/<user //' -e 's| roles="jolokia"/>||' | \
      awk -F'"' '{ printf "%s:%s\n", $2, $4 }')

    curl_opts="${curl_opts} --user ${credentials}"
  fi
fi

if curl ${curl_opts} http://localhost:8080/jolokia
then
  # validation are not successful
  #
  if [[ $? -gt 0 ]]
  then
    exit 1
  fi

  exit 0
fi

exit 2
