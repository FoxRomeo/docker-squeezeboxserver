#!/bin/bash

############################################################
# run_server
#
# Run squeezeboxserver
#
# WS 20160117
# modified FoxRomeo 202102
############################################################

if ! . /etc/default/lyrionmusicserver ; then
  echo "ERROR: Could not read /etc/default/lyrionmusicserver" >&2
  exit 1
fi


for SUBDIR in "$PREFSDIR" "$LOGDIR" "$CACHEDIR"; do
  if [ ! -d "${SUBDIR}" ]; then
    if [ -e "${SUBDIR}" ]; then
      echo "ERROR: ${SUBDIR} existing but not a directory"
      exit 2
    else
      mkdir -p "$SQUEEZE_BASE/${SUBDIR}"
      chown -R ${SLIMUSER}:nogroup "$SQUEEZE_BASE/${SUBDIR}"
    fi
  fi
done

chown squeezeboxserver /usr/share/perl5/Slim /var/lib/squeezeboxserver /var/log/squeezeboxserver "${SQUEEZE_BASE}" -R

stopping () {
echo "Exiting..."
  /etc/init.d/lyrionmusicserver stop
}

trap 'stopping' 0

/etc/init.d/lyrionmusicserver start

# Keep running so we can exit cleanly
while true; do
  sleep 5m
done

