#!/usr/bin/env bash

# Versions
export MONGO_VERSION="2.6.7"
export MONGO_PORT="27017"

# MongoDB
# Taken from: http://docs.mongodb.org/v2.6/tutorial/install-mongodb-on-ubuntu/
# Taken from: https://github.com/fideloper/Vaprobash/blob/master/scripts/mongodb.sh
echo "[mongo] Setting up MongoDB..."

# Install MongoDB
# -qq implies -y --force-yes
sudo apt-get install -qq mongodb-org=${MONGO_VERSION} mongodb-org-server=${MONGO_VERSION} mongodb-org-shell=${MONGO_VERSION} mongodb-org-mongos=${MONGO_VERSION} mongodb-org-tools=${MONGO_VERSION}

# Pin specific version of MongoDB
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# Enable remote access by commenting out bind_ip
sudo sed -in '/bind_ip/s/^/#/' /etc/mongod.conf
# Restart service for config change to take effect
sudo service mongod restart

# Test if PHP is installed
echo "[mongo] Checking PHP for MongoDB..."
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

if [ $PHP_IS_INSTALLED -eq 0 ]; then
    # install dependencies
    sudo apt-get -y install php-pear php5-dev

    # install php extension
    echo "no" > answers.txt
    sudo pecl install mongo < answers.txt
    rm answers.txt

    # add extension file and restart service
    echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini

    ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/mongo.ini
    ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/mongo.ini
    sudo service php5-fpm restart
fi

sleep 1
while ! grep -m1 "\[initandlisten\] waiting for connections on port ${MONGO_PORT}" < /var/log/mongodb/mongod.log; do
    echo "[mongo] Waiting for Mongo to start..."
    sleep 1
done

echo "[mongo] MongoDB started"
