#!/bin/sh

set -x

startSupervisor() {

  echo -e "\n Starting Supervisor.\n\n"

  if [ -f /etc/supervisord.conf ]
  then
    /usr/bin/supervisord -c /etc/supervisord.conf >> /dev/null
  else
    exec /bin/sh
  fi
}


run() {

  echo -e "\n"
  echo " ==================================================================="
  echo " starting tomcat with joloika webapp"
  echo " ==================================================================="
  echo ""

  startSupervisor
}

run


# /bin/sh -e /opt/tomcat/bin/catalina.sh run 2> /dev/null

# EOF
