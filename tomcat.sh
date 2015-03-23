#!/usr/bin/env bash
# exit immediately on errors
set -e
cd

# Tomcat version
TOMCAT_VERSION="7.0.59"

# config stuff ... directories! Lots of 'm!
HOME=~
GIT_HOME=$HOME/git
CORELIB_HOME=$GIT_HOME/corelib
API_HOME=$GIT_HOME/api2
PROJECT_DIR="$HOME"/git
TOMCAT_DIR=apache-tomcat-$TOMCAT_VERSION
TOMCAT_TGZ=$TOMCAT_DIR'.tar.gz'
TOMCAT_WEBAPP_DIR="$TOMCAT_DIR"/webapps
TOMCAT_WORK_DIR="$TOMCAT_DIR"/work/Catalina/localhost
# URL="http://localhost:8080/portal/"

echo "[tomcat] Getting & installing Apache Tomcat ..."
wget 'http://apache.proserve.nl/tomcat/tomcat-7/v'$TOMCAT_VERSION'/bin/'$TOMCAT_TGZ
tar -xf $TOMCAT_TGZ
rm $TOMCAT_TGZ

echo "[tomcat] Starting Tomcat ..."
# include options
CATALINA_OPTS='-Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=1024M'
# when debugging use this
# CATALINA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

EUROPEANA_OPTS=-DEUROPEANA_PROPERTIES=$EUROPEANA_PROPERTIES
export CATALINA_OPTS=$CATALINA_OPTS" "$EUROPEANA_OPTS
export JAVA_OPTS=" -Xms512m -Xmx1024m -XX:MaxPermSize=256m -XX:-UseSplitVerifier"

# copy api war's
cp $API_HOME/api2-demo/target/api-demo.war $TOMCAT_WEBAPP_DIR
cp $API_HOME/api2-war/target/api.war $TOMCAT_WEBAPP_DIR

# startup tomcat
apache-tomcat-${TOMCAT_VERSION}/bin/startup.sh
echo "[tomcat] Tomcat started."