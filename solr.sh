#!/usr/bin/env bash

# Versions
export SOLR_VERSION="4.10.1"
export SOLR_NAME="solr-"${SOLR_VERSION}

# Solr
# Taken from: http://docs.mongodb.org/v2.6/tutorial/install-mongodb-on-ubuntu/
# Taken from: https://github.com/fideloper/Vaprobash/blob/master/scripts/mongodb.sh
wget --quiet - https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/${SOLR_NAME}.tgz
tar -xvvf ${SOLR_NAME}.tgz

rm ${SOLR_NAME}.tgz
cd ${SOLR_NAME}/example/

# Solr startup
java -jar start.jar > /tmp/solr-server-log.txt &

echo "[databases] Setting up Apache Solr..."

sleep 1
while ! grep -m1 "Registered new searcher" < /tmp/solr-server-log.txt; do
    echo "[databases] Waiting for Solr to start..."
    sleep 1
done

echo "[databases] Apache Solr started. Index test data ..."

# Index some stuff
cd exampledocs/
java -jar post.jar solr.xml monitor.xml

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  exit
fi