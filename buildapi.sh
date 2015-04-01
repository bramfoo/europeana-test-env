#!/usr/bin/env bash
# exit immediately on errors
set -e
cd

# directories! Lots of 'm!
GIT_HOME=$HOME/git
CORELIB_HOME=$GIT_HOME/corelib
API_HOME=$GIT_HOME/api2
CORELIB_GIT_URL="https://github.com/europeana/corelib.git"
API_GIT_URL="https://github.com/europeana/api2.git"
GIT_BRANCH="develop"
PROPERTY_FILE_DIR="/vagrant"
PROPERTY_FILE="europeana.properties"
EUROPEANA_PROPERTIES=$PROPERTY_FILE_DIR"/"$PROPERTY_FILE

TOMCAT_VERSION="7.0.59"
TOMCAT_DIR=apache-tomcat-$TOMCAT_VERSION
TOMCAT_WEBAPP_DIR="$TOMCAT_DIR"/webapps


# remove directories if existing, re-create them
echo "[build api] creating directories ..."
if [ -d $API_HOME ]; then
  rm -r $API_HOME
fi
if [ -d $CORELIB_HOME ]; then
  rm -r $CORELIB_HOME
fi
mkdir -p $CORELIB_HOME
mkdir -p $API_HOME

# checkout from github
echo "[build api] clone CORELIB and API from github..."
cd $GIT_HOME
git clone $CORELIB_GIT_URL
git clone $API_GIT_URL

# change to desired build
if [ $GIT_BRANCH != "master" ]; then
  cd $CORELIB_HOME
  echo "[build api] checking out desired git branch '$GIT_BRANCH' for CoreLib ..."
  git checkout $GIT_BRANCH
  cd $API_HOME
  echo "[build api] checking out desired git branch '$GIT_BRANCH' for API ..."
  git checkout $GIT_BRANCH
fi

# copy in europeana.properties
echo "[build api] copying $EUROPEANA_PROPERTIES to $API_HOME/properties/personal/ ..."
mkdir -p "$API_HOME/properties/personal/"
cp $EUROPEANA_PROPERTIES "$API_HOME/properties/personal/"

# building corelib
echo "[build api] Building CoreLib ... (fetching dependencies may take a while)"
cd $CORELIB_HOME
mvn -q clean install -DskipTests
echo "[build api] CoreLib successfully built. Building API ... (fetching dependencies may take a while)"
cd $API_HOME
mvn -q clean install -DskipTests -P personal
echo "[build api] API successfully built."

# copy api wars to Tomcat
#cp $API_HOME/api2-demo/target/api-demo.war $TOMCAT_WEBAPP_DIR
cp ${API_HOME}/api2-war/target/api.war ${HOME}/${TOMCAT_WEBAPP_DIR}