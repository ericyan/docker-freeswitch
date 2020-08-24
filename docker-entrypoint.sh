#!/bin/bash
set -e

for f in /etc/freeswitch/vars/*.xml; do
  if [ ! -f $f.tmpl ]; then
    cp $f $f.tmpl
  fi
  envsubst < $f.tmpl > $f
done
chown -R freeswitch:freeswitch /etc/freeswitch

if [ "$1" = 'freeswitch' ]; then
  exec chroot --userspec=freeswitch / /usr/bin/freeswitch -u freeswitch -g freeswitch -c -nonat
fi

exec "$@"
