#!/bin/sh

echo -e "\n Starting Tomcat.\n\n"

/bin/sh -e /opt/tomcat/bin/catalina.sh run 2> /dev/null

# EOF
