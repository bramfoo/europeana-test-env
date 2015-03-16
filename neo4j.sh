#!/usr/bin/env bash

# Versions
export NEO4J_VERSION="2.1.5"

# Neo4j
# Taken from: http://debian.neo4j.org/
sudo apt-get install -qq neo4j-${NEO4J_VERSION}

#wget -nv http://dist.neo4j.org/neo4j-community-${NEO4J_VERSION}-unix.tar.gz
#tar -xf neo4j-community-${NEO4J_VERSION}-unix.tar.gz
#rm neo4j-community-${NEO4J_VERSION}-unix.tar.gz
#sudo /etc/init.d/neo4j-service restart