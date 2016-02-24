#!/usr/bin/env bash

# this runs as root
set -x

source library-functions.sh

# install node
install_node

# create /opt/histograph and set as user home
mkdir -p /opt/histograph
chown -R spacetime:spacetime /opt/histograph
chmod -R g+rwX /opt/histograph

mkdir -p /opt/histograph-data
chown -R spacetime:spacetime /opt/histograph-data
chmod -R g+rwX /opt/histograph-data

# dir for configs
# TODO rename dir? remove?
mkdir /opt/histograph/run

# dirs for log and PID files
mkdir -p /var/log/histograph /var/run/histograph
chown histograph:histograph /var/log/histograph/ /var/run/histograph/

# install histograph

cd /opt/histograph

cat > setup.sh << SETUP

# clean up
rm -rf ~/api

# clone master branch
git clone https://github.com/nypl-spacetime/histograph-api

# install node dependencies
cd ~/api
npm install
SETUP

chmod +x /opt/histograph/setup.sh
su spacetime /opt/histograph/setup.sh

# ensure ownership of dirs where node packages end up
chown -R spacetime /opt/histograph/.npm
chown -R spacetime /usr/local/lib/node_modules

# install forever, create init.d scripts
install_forever
install_service api

# start it now ?
service histograph-api start
service histograph-api status
