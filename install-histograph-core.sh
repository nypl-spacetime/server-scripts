#!/usr/bin/env bash

# this runs as root
set -x

source library-functions.sh

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
chown -R spacetime:spacetime /var/log/histograph/ /var/run/histograph/

# install histograph

cd /opt/histograph

cat > setup.sh << SETUP

# clean up
rm -rf /opt/histograph/histograph-core

# clone master branch
git clone https://github.com/nypl-spacetime/histograph-core

# install node dependencies
cd /opt/histograph/histograph-core
npm install
SETUP

chmod +x /opt/histograph/setup.sh
su spacetime /opt/histograph/setup.sh

# ensure ownership of dirs where node packages end up
chown -R spacetime /opt/histograph/.npm
chown -R spacetime /usr/local/lib/node_modules

# install forever, create init.d scripts
# install_forever
install_service histograph-core

# start it now ?
service histograph-core start
service histograph-core status
