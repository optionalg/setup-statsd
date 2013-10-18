#!/bin/bash

function escapeSearchPattern
{
    echo "$(echo "${1}" | sed "s@\[@\\\\[@g")"
}

function installDependencies
{
    apt-get update
    apt-get -y upgrade

    apt-get -y install build-essential
}

function installNode
{
    mkdir -p '/opt/node'
    curl -L 'http://nodejs.org/dist/v0.10.20/node-v0.10.20-linux-x64.tar.gz' | tar xz --strip 1 -C '/opt/node'

    echo 'export PATH="/opt/node/bin:$PATH"' > '/etc/profile.d/node.sh'
    source '/etc/profile.d/node.sh'
}

function installNodeApps
{
    /opt/node/bin/npm install -g forever
}

function installStatSD
{
    cd '/opt'
    git clone 'https://github.com/etsy/statsd.git'

    cp "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/config/config.js" '/opt/statsd/config.js'

    cd '/opt/statsd'
    /opt/node/bin/npm install
}

function startServers
{
    mkdir -p /var/log/statsd
    /opt/node/bin/forever start -a -o '/var/log/statsd/out.log' -e '/var/log/statsd/error.log' '/opt/statsd/stats.js' '/opt/statsd/config.js'
}

function main
{
    installDependencies
    installNode
    installNodeApps
    installStatSD

    startServers
}

main "${@}"
