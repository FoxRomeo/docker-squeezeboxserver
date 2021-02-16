#!/bin/bash

############################################################
# run_server
#
# Run squeezeboxserver
#
# WS 20160117
# modified FoxRomeo 202102
############################################################

if ! . /etc/default/logitechmediaserver ; then
  echo "Error: Could not read /etc/default/logitechmediaserver" >&2
  exit 1
fi

stopping () {
echo "Exiting..."
service logitechmediaserver stop
}

trap 'stopping' 0

service logitechmediaserver start

# Keep running so we can exit cleanly
while true; do
  sleep 1h
done

