#!/bin/bash

usage() {
    echo ""
    echo "${0} <datacenter> <hostname> <encrypt> <private ip 1> <private ip 2>"
    echo ""
    echo "Arguments"
    echo "Datacenter     - [REQUIRED] The datacenter name you want to provide for your custler."
    echo "Hostname       - [REQUIRED] The hostname you want to provide for your consul agent."
    echo "Encrypt        - [REQUIRED] This is acquired by running consul keygen."
    echo "Private IP 1   - [REQUIRED] The private IP address of the bootstrap server."
    echo "Private IP 2   - [REQUIRED] The private IP address of the non bootstrap server."
    echo ""

    return
}

# Check to make sure the correct number of arguments is passed.
if [ "$#" -ne 5 ]; 
then
    usage
    exit
fi

DATACENTER=$1
HOSTNAME=$2
ENCRYPT=$3
PRIVATE_IP1=$
PRIVATE_IP2=$4

sed -i -- "s/__DATACENTER__/$DATACENTER/g" server-config.json
sed -i -- "s/__NODE_NAME__/$HOSTNAME/g" server-config.json
sed -i -- "s/__ENCRYPT__/$ENCRYPT/g" server-config.json
sed -i -- "s/__BIND_ADDR__/$PRIVATE_IP1/g" server-config.json
sed -i -- "s/__START_JOIN__/$PRIVATE_IP2/g" server-config.json

mv scripts/* /home/consul/consul_scripts/

nohup consul agent -config-dir ./server-config.json &