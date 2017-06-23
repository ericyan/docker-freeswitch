#!/bin/bash
set -e

for f in /etc/freeswitch/vars.xml.d/*.xml; do
  mv $f /tmp/vars.xml.tmpl
  envsubst < /tmp/vars.xml.tmpl > $f
done
chown -R freeswitch:freeswitch /etc/freeswitch

if [ "$1" = 'freeswitch' ]; then
  setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/freeswitch
  exec chroot --userspec=freeswitch / /usr/bin/freeswitch -u freeswitch -g freeswitch -c -nonat
fi

exec "$@"
