#!/bin/bash

IP_ADDRESS="127.0.0.1"

PORT_START=1

PORT_END=1024

TYPE=tcp

SERVICE=false

OPTIONS=":i:ahtu?"

usage()
{
    echo '
    <options>
    -i [ip] : ip설정
    -a : 서비스에 관한 설명까지 추가되어 출력
    -h : 도움말
    -t : tcp 스캔 (default)
    -u : udp 스캔
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
    t) TYPE=tcp
    ;;
    u) TYPE=udp
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
        if [ $TYPE == 'tcp' ]; then
            (echo >/dev/tcp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/tcp\topen\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $1}'`\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $4}'`"
        else
            (echo >/dev/udp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/udp\topen\t`grep $PORT/udp /etc/services | head -n1 | awk '{print $1}'`\t`grep $PORT/udp /etc/services | head -n1 | awk '{print $4}'`"
        fi
    else
        if [ $TYPE == 'tcp' ]; then
            (echo >/dev/tcp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/tcp\topen\t`grep $PORT/tcp /etc/services | head -n1 | awk '{print $1}'`"
        else
            (echo >/dev/udp/"$IP_ADDRESS"/"$PORT") &>/dev/null && echo -e "$PORT/udp\topen\t`grep $PORT/udp /etc/services | head -n1 | awk '{print $1}'`"
        fi
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