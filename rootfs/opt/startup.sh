#!/bin/sh

echo "192.168.252.100 blueprint-box" >> /etc/hosts

/bin/sh -e /opt/tomcat/bin/catalina.sh run 2> /dev/null

# EOF
