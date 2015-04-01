#!/usr/bin/env bash

# Dependencies: tomcat.sh

# Versions
export SOLR_VERSION="4.10.1"
export SOLR_NAME="solr-"${SOLR_VERSION}
export SOLR_HOME="solrhome"


# Solr
# Inspired by: http://blog.andresteingress.com/2014/04/06/vagrant-solr-box/
echo "[solr] Downloading Apache Solr..."
wget --quiet https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/${SOLR_NAME}.tgz
tar -xf ${SOLR_NAME}.tgz
rm ${SOLR_NAME}.tgz

# Read in user variables -- these may not be active yet
source $HOME/.profile

if [ -z "$TOMCAT_DIR" ]
then
	# Run Solr as jar
	echo "[solr] Running Apache Solr as jar..."
	$SOLR_NAME/bin/solr start # This script checks for start-up

	## FIXME ## 
	# This setup may not be fully configured yet
else
	# Deploy Solr war to Tomcat
	echo "[solr] Deploying Apache Solr war into ${HOME}/${TOMCAT_DIR}..."

	echo "[solr] Configuring solrHome and restarting Tomcat..."	
	# Set up logging (http://wiki.apache.org/solr/SolrLogging)
	mkdir -p ${HOME}/${SOLR_HOME}/
	cp -R ${SOLR_NAME}/example/solr ${HOME}/${SOLR_HOME}/
	mkdir -p ${HOME}/${SOLR_HOME}/lib/
	cp ${SOLR_NAME}/example/lib/ext/*.jar ${HOME}/${TOMCAT_DIR}/lib/
	mkdir -p ${HOME}/${SOLR_HOME}/webapps/
	cp ${SOLR_NAME}/dist/${SOLR_NAME}.war ${HOME}/${SOLR_HOME}/webapps/solr.war
	cp /vagrant/solr.xml ${TOMCAT_DIR}/conf/Catalina/localhost/

	cp ${SOLR_NAME}/example/resources/log4j.properties ${HOME}/${SOLR_HOME}/
	# Remove logs/ directory in config
	sed -i 's|logs/|'"${HOME}/${TOMCAT_DIR}/logs"'|' ${HOME}/${SOLR_HOME}/log4j.properties
	export JAVA_OPTS="$JAVA_OPTS -Dlog4j.configuration=file:${HOME}/${SOLR_HOME}/log4j.properties"
	echo 'export JAVA_OPTS="$JAVA_OPTS -Dlog4j.configuration=file:${HOME}/${SOLR_HOME}/log4j.properties"' >> $HOME/.profile

	# Restart Tomcat for logging jars and properties to take effect
	${HOME}/${TOMCAT_DIR}/bin/shutdown.sh
	sleep 5
	${HOME}/${TOMCAT_DIR}/bin/startup.sh

	sleep 1
	while ! grep -m1 "Registered new searcher" < ${HOME}/${TOMCAT_DIR}/logs/solr.log; do
	    echo "[solr] Waiting for Solr to start..."
	    sleep 1
	done
fi

echo "[solr] Apache Solr started."