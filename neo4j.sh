#!/usr/bin/env bash

# Versions
export NEO4J_VERSION="2.1.5"

# Neo4j
# Taken from: http://debian.neo4j.org/
sudo apt-get install -qq neo4j=${NEO4J_VERSION}

# Create a sparse clone, as only a small part of the repository is required
# Taken from: http://stackoverflow.com/a/13738951
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
mv target/neo4j-startup-plugin-0.1-SNAPSHOT.jar ~ #FIXME
cd ..

cd neo4j-count-hierarchies
mvn clean install -DskipTests
mv target/neo4j-count-hierarchies-0.1-SNAPSHOT.jar ~ #FIXME
cd ..

#wget -nv http://dist.neo4j.org/neo4j-community-${NEO4J_VERSION}-unix.tar.gz
#tar -xf neo4j-community-${NEO4J_VERSION}-unix.tar.gz
#rm neo4j-community-${NEO4J_VERSION}-unix.tar.gz
#sudo /etc/init.d/neo4j-service restart