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
GIT_BRANCH="master"
PROPERTY_FILE_DIR="/vagrant"
PROPERTY_FILE="europeana.properties"
EUROPEANA_PROPERTIES=$PROPERTY_FILE_DIR"/"$PROPERTY_FILE

# Read in user variables -- these may not be active yet
source $HOME/.profile

if [ -z "$TOMCAT_DIR" ]
then
	echo "Tomcat is required, but not installed, quitting..."
	exit 0
fi

# remove directories if existing, re-create them
echo "[API] creating directories ..."
if [ -d $API_HOME ]; then
  rm -r $API_HOME
fi
if [ -d $CORELIB_HOME ]; then
  rm -r $CORELIB_HOME
fi
mkdir -p $CORELIB_HOME
mkdir -p $API_HOME

# checkout from github
echo "[API] Cloning CoreLib and API from Github..."
cd $GIT_HOME
git clone $CORELIB_GIT_URL
git clone $API_GIT_URL

# change to desired build
if [ $GIT_BRANCH != "master" ]; then
  cd $CORELIB_HOME
  echo "[API] Checking out desired git branch '$GIT_BRANCH' for CoreLib ..."
  git checkout $GIT_BRANCH
  cd $API_HOME
  echo "[API] Checking out desired git branch '$GIT_BRANCH' for API ..."
  git checkout $GIT_BRANCH
else
  echo "[API] Using $GIT_BRANCH to build CoreLib/API"
fi

# copy in europeana.properties
echo "[API] Copying $EUROPEANA_PROPERTIES to $API_HOME/properties/personal/ ..."
mkdir -p "$API_HOME/properties/personal/"
cp $EUROPEANA_PROPERTIES "$API_HOME/properties/personal/"

# building corelib
echo "[API] Building CoreLib ... (fetching dependencies may take a while)"
cd $CORELIB_HOME
mvn -q clean install -DskipTests
echo "[API] CoreLib successfully built. Building API ... (fetching dependencies may take a while)"
cd $API_HOME
mvn -q clean install -DskipTests -P personal
echo "[API] API successfully built."

# copy api wars to Tomcat
#cp $API_HOME/api2-demo/target/api-demo.war $TOMCAT_WEBAPP_DIR
cp ${API_HOME}/api2-war/target/api.war ${HOME}/${TOMCAT_DIR}/webapps