#!/usr/bin/env bash
# exit immediately on errors
set -e
cd

# Tomcat version
TOMCAT_VERSION="7.0.59"

# config stuff ... directories! Lots of 'm!
TOMCAT_DIR=apache-tomcat-$TOMCAT_VERSION
TOMCAT_TGZ=$TOMCAT_DIR'.tar.gz'
TOMCAT_WEBAPP_DIR="$TOMCAT_DIR"/webapps
TOMCAT_WORK_DIR="$TOMCAT_DIR"/work/Catalina/localhost

echo "[tomcat] Getting & installing Apache Tomcat ..."
wget --quiet 'http://archive.apache.org/dist/tomcat/tomcat-7/v'$TOMCAT_VERSION'/bin/'$TOMCAT_TGZ
tar -xf $TOMCAT_TGZ
rm $TOMCAT_TGZ

echo "[tomcat] Starting Tomcat ..."
# include options
CATALINA_OPTS="$CATALINA_OPTS -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=1024M"
# when debugging use this
# CATALINA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

EUROPEANA_OPTS=-DEUROPEANA_PROPERTIES=$EUROPEANA_PROPERTIES
export CATALINA_OPTS="$CATALINA_OPTS $EUROPEANA_OPTS"
echo 'export CATALINA_OPTS="$CATALINA_OPTS $EUROPEANA_OPTS"' >> $HOME/.profile
export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m -XX:MaxPermSize=256m -XX:-UseSplitVerifier"
echo 'export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m -XX:MaxPermSize=256m -XX:-UseSplitVerifier"' >> $HOME/.profile

# Enable HTML GUI and status page access
# From: http://stackoverflow.com/a/11695086
sed -i '/<\/tomcat-users>/i \
<role rolename="manager-gui"/> \
<role rolename="admin"/> \
<user username="admin" password="admin" roles="admin,manager-gui"\/>' $TOMCAT_DIR/conf/tomcat-users.xml

# Install startup script
# From: http://askubuntu.com/a/224402
sudo cp /vagrant/tomcat_init.sh /etc/init.d/tomcat7
sudo chmod 755 /etc/init.d/tomcat7
sudo update-rc.d tomcat7 defaults

# startup tomcat
sudo service tomcat7 start
echo "[tomcat] Tomcat started"

# Create user variables (for use in other scripts)
echo "export TOMCAT_DIR=$TOMCAT_DIR" >> $HOME/.profile