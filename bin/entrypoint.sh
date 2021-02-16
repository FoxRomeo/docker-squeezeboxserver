#!/bin/sh

if ! . /etc/default/logitechmediaserver ; then
  echo "Error: Could not read /etc/default/logitechmediaserver" >&2
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

exec "$@"

