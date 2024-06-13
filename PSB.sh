#!/bin/bash

IP_ADDRESS=${1:-"127.0.0.1"}

PORT_START=${2:-1}

PORT_END=${3:-1024}

scan_port(){
    PORT=$1
    (echo >/dev/tcp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/tcp\topen\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $1}'`"
    sleep 0.01
}

clear
echo "Scanning $IP_ADDRESS [TCP ports $PORT_START to $PORT_END]"

echo -e "\nPORT\tSTATE\tSERVICE"

for (( PORT=PORT_START; PORT<=PORT_END; PORT++ ))
do
    scan_port $PORT
done