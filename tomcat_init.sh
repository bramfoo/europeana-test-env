#!/bin/bash

### BEGIN INIT INFO
# Provides:        tomcat7
# Required-Start:  $network
# Required-Stop:   $network
# Default-Start:   2 3 4 5
# Default-Stop:    0 1 6
# Short-Description: Start/Stop Tomcat server
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin
TOMCAT_USER=vagrant
TOMCAT_VERSION="7.0.59"
TOMCAT_DIR=/home/vagrant/apache-tomcat-$TOMCAT_VERSION

start() {
 su $TOMCAT_USER -c ${TOMCAT_DIR}/bin/startup.sh
}

stop() {
 su $TOMCAT_USER -c ${TOMCAT_DIR}/bin/shutdown.sh
}

case $1 in
  start|stop) $1;;
  restart) stop; start;;
  *) echo "Run as $0 <start|stop|restart>"; exit 1;;
esac 
