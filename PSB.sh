#!/bin/bash

IP_ADDRESS="127.0.0.1"

PORT_START=1

PORT_END=1024

SERVICE=false

OPTIONS=":i:ah?"

usage()
{
    echo '
    <options>
    -i [ip] : ip설정
    -a : 서비스에 관한 설명까지 추가되어 출력
    -h : 도움말
    '
}

while getopts $OPTIONS opts; do
    case $opts in
    \?)
    echo "invalid option"
    usage
    exit 1;;
    a) SERVICE=true
    ;;
    i) IP_ADDRESS=$OPTARG
    ;;
    h)
        usage
    exit;;
    :)
        usage
    exit;;
    esac
done

scan_port(){
    PORT=$1
    if [ $SERVICE = true ]; then
        (echo >/dev/tcp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/tcp\topen\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $1}'`\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $4}'`"
    else
        (echo >/dev/tcp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/tcp\topen\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $1}'`"
    fi
    sleep 0.01
}

clear
echo "Scanning $IP_ADDRESS [TCP ports $PORT_START to $PORT_END]"

echo -e "\nPORT\tSTATE\tSERVICE"

for (( PORT=PORT_START; PORT<=PORT_END; PORT++ ))
do
    scan_port $PORT
done