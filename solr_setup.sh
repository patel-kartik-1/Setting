#!/bin/bash
# Run this bash file with one argument which is solr version like 9.4.0

# Check if an argument is provided for SOLR_VERSION
if [ -z "$1" ]; then
    echo "Please provide the SOLR_VERSION as an argument."
    exit 1
fi

SOLR_VERSION="$1"

# Install default JDK
apt-get update
apt-get install default-jdk -y
java -version

# Download and install Solr
wget https://dlcdn.apache.org/solr/solr/"${SOLR_VERSION}"/solr-"${SOLR_VERSION}".tgz
tar xzf solr-"${SOLR_VERSION}".tgz solr-"${SOLR_VERSION}"/bin/install_solr_service.sh --strip-components=2
bash ./install_solr_service.sh solr-"${SOLR_VERSION}".tgz

# Manage Solr service
systemctl stop solr
systemctl start solr
systemctl status solr
systemctl enable solr

# Allow traffic on port 8983
ufw allow 8983
