#!/bin/bash

function installDependencies
{
    apt-get update
    apt-get -y upgrade
    apt-get -y install build-essential
    apt-get -y nodejs
}

function installStatSD
{
    cd '/usr/share'
    git clone 'https://github.com/etsy/statsd.git'
    cd '/usr/share/statsd'
    npm install

    cp "${appPath}/config/config.js" '/etc/statsd/localConfig.js'

    cp "${appPath}/files/statsd.conf" '/etc/init/statsd.conf'
}

function startServers
{
    service statsd start
}

function main
{
    appPath="$(cd "$(dirname "${0}")" && pwd)"

    installDependencies
    installStatSD

    startServers
}

main "${@}"
