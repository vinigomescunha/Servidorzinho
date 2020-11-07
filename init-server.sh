#!/bin/bash
# use ncat from nmap.org shortcut nc or netcat with options -e sudo apt get install ncat or compile
[ -f ./server.conf ] && source ./server.conf || echo "Without server conf";
[ ! -z "${PORT}" ] && echo " Init port $PORT" && while (ncat -l -k -p $PORT -e ./server.sh);do echo $? && echo "$1";done || echo "ERROR PORT NOT FOUND"
##while (nc -l  -p 8000 -e ./server.sh);do echo $? && echo "$1";done
