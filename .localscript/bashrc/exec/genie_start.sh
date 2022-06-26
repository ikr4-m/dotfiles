#!/bin/sh
UDP_URL=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
SWITCH_MODE=$1

if [ $SWITCH_MODE = "up" ]
then
  genie -i
  echo "Genie connected to ${UDP_URL} address!"
elif [ $SWITCH_MODE = "shell" ]
then
  echo "Connecting Genie shell to ${UDP_URL} address..."
  genie -s
  echo "Connection closed!"
elif [ $SWITCH_MODE = "down" ]
then
  genie -u
  echo "Genie shutting down!"
else
  echo "Usage: genie_start.sh <up|shell|down>"
fi

