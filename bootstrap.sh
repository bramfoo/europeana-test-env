#!/usr/bin/env bash

# Environment variables. Mongo is picky about these
# https://help.ubuntu.com/community/Locale
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=C
locale-gen en_US.UTF-8
update-locale LANG=${LANG} LC_ALL=${LC_ALL}

# Update all packages, repositories (Java, Mongo, PostgreSQL, Neo4j)
echo
echo '[bootstrap] Updating all packages (apt-get update/upgrade)...'
echo '----------------'
# Add repo keys
add-apt-repository -y ppa:webupd8team/java
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
wget --quiet -O - http://debian.neo4j.org/neotechnology.gpg.key| apt-key add -
# Add repo sources
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list
# Do the update/upgrade
apt-get update > /dev/null
apt-get -y upgrade > /dev/null
echo '[bootstrap] Packages updated'
echo

# Java 7
echo '[bootstrap] Installing Java 7'
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get -y install oracle-java7-set-default > /dev/null
export JAVA_HOME="/usr/lib/jvm/java-7-oracle/jre"
echo '[bootstrap] Java 7 installed'