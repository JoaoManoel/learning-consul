#!/bin/bash

usage() {
    echo ""
    echo "${0} <datacenter> <hostname> <encrypt> <private ip 1> <private ip 2>"
    echo ""
    echo "Arguments"
    echo "Type           - [REQUIRED] Type of agent (bootstrap, server, client)."
    echo "Datacenter     - [REQUIRED] The datacenter name you want to provide for your cluster."
    echo "Hostname       - [REQUIRED] The hostname you want to provide for your consul agent."
    echo "Encrypt        - [REQUIRED] This is acquired by running consul keygen."
    echo "Private IP 1   - [REQUIRED] The private IP address of the bootstrap server."
    echo "Private IP 2   - [REQUIRED] The private IP address of the non bootstrap server."
    echo ""

    return
}

generate_json() {
    sed -i -- "s/__NODE_NAME__/$HOSTNAME/g" "$1.json"
    sed -i -- "s/__ENCRYPT__/$ENCRYPT/g" "$1.json"
    sed -i -- "s/__START_JOIN__/$PRIVATE_IP1/g" "$1.json"
    sed -i -- "s/__BIND_ADDR__/$PRIVATE_IP2/g" "$1.json"
    nohup consul agent -config-dir server-config.json &
}

# Check to make sure the correct number of arguments is passed.
if [ "$#" -ne 6 ]; 
then
    usage
    exit
fi

TYPE=$(echo "$1" | tr '[:upper:]' '[:lower:]')
DATACENTER=$2
HOSTNAME=$3
ENCRYPT=$4
PRIVATE_IP1=$5
PRIVATE_IP2=$6

if [  "$TYPE" == "bootstrap" -o  "$TYPE" == "server" -o "$TYPE" == "client" ]; 
then
    cp scripts/* /home/consul/consul_scripts/
    case $TYPE in
        bootstrap)
            generate_json "bootstrap-config"
            ;;
        server)
            generate_json "server-config"
            ;;
        client)
            generate_json "client-config"
            ;;
    esac
else
    echo "$TYPE is a invalid type of agent"
fi