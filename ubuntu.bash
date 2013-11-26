#!/bin/bash

function installDependencies
{
    apt-get update
    apt-add-repository -y ppa:chris-lea/node.js
    apt-get -y upgrade
    apt-get -y install build-essential
    apt-get -y install nodejs
}

function installStatSD
{
    mkdir -p /etc/statsd/
    mkdir -p /etc/pong/
    cp ./config/config.js '/etc/statsd/localConfig.js'
    cp ./config/pong.json '/etc/pong/config.json'
    cp ./files/statsd.conf '/etc/init/statsd.conf'
    cp ./files/pong.conf '/etc/init/pong.conf'

    cd '/usr/share'
    git clone 'https://github.com/etsy/statsd.git'
    cd '/usr/share/statsd'
    npm install

    cd '/usr/share'
    git clone 'https://github.com/mapbox/pong.git'
    git clone 'https://github.com/bluesmoon/node-geoip.git'
    cd '/usr/share/pong'
    npm install
    cp /usr/share/node-geoip/data/*.dat /usr/share/pong/node_modules/geoip-lite/data/
}

function startServers
{
    service statsd start
    service pong start
}

function main
{
    appPath="$(cd "$(dirname "${0}")" && pwd)"

    installDependencies
    installStatSD

    startServers
}

main "${@}"
