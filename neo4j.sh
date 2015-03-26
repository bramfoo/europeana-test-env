#!/usr/bin/env bash

# Versions
GIT_HOME=~/git
NEO4J_VERSION="2.1.4"
NEO4J_DIR=neo4j-community-${NEO4J_VERSION}
PLUGIN_DIR=$NEO4J_DIR/plugins

# Neo4j
echo "[neo4j] Setting up Neo4j..."
wget -nv http://dist.neo4j.org/neo4j-community-${NEO4J_VERSION}-unix.tar.gz
tar -xf neo4j-community-${NEO4J_VERSION}-unix.tar.gz
rm neo4j-community-${NEO4J_VERSION}-unix.tar.gz

# Configuration
# Allow any connection (not only localhost)
sudo sed -inE '/^#.*address/s/^#//' $NEO4J_DIR/conf/neo4j-server.properties
# Add plugins
sed -i '/thirdparty_jaxrs_classes/a \
org.neo4j.server.thirdparty_jaxrs_classes=eu.europeana.neo4j.count=/europeana,eu.europeana.neo4j.initial=/initial,eu.europeana.neo4j.delete=/delete' $NEO4J_DIR/conf/neo4j-server.properties

# Run installer
sudo $NEO4J_DIR/bin/neo4j-installer install

# Create a sparse clone, as only a small part of the repository is required
# Taken from: http://stackoverflow.com/a/13738951
echo "[neo4j] Building Neo4j plugins... (fetching repository may take a while)"
mkdir -p $GIT_HOME
cd $GIT_HOME
git init tools_neo4j
cd tools_neo4j
git remote add -f origin https://github.com/europeana/tools.git

git config core.sparseCheckout true

# Define projects to check out
echo "neo4j-count-hierarchies" >> .git/info/sparse-checkout
echo "neo4j-startup-plugin" >> .git/info/sparse-checkout
git pull origin master

# Build plugins
cd neo4j-startup-plugin
mvn clean install -DskipTests
sudo mv target/neo4j-startup-plugin-0.1-SNAPSHOT.jar $PLUGIN_DIR
cd ..

cd neo4j-count-hierarchies
mvn clean install -DskipTests
sudo mv target/neo4j-count-hierarchies-0.1-SNAPSHOT.jar $PLUGIN_DIR
cd ..

# (Re)start Neo4j for plugins to take effect
sudo service neo4j-service start

# Old method of installing
# Taken from: http://debian.neo4j.org/
#sudo apt-get install -qq neo4j=${NEO4J_VERSION}
