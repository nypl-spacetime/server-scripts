#!/usr/bin/env bash

# this runs as root
set -x

source library-functions.sh

# install node
install_node

# create /opt/histograph
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
chown -R histograph:histograph /var/log/histograph/ /var/run/histograph/

# install histograph

cd /opt/histograph

cat > setup.sh << SETUP

# clean up
rm -rf ~/core

# clone master branch
git clone https://github.com/nypl-spacetime/histograph-core

# install node dependencies
cd ~/core
npm install
SETUP

chmod +x /opt/histograph/setup.sh
su spacetime /opt/histograph/setup.sh

# ensure ownership of dirs where node packages end up
chown -R histograph /opt/histograph/.npm
chown -R histograph /usr/local/lib/node_modules

# install forever, create init.d scripts
install_forever
install_service core

# start it now ?
service histograph-core start
service histograph-core status
