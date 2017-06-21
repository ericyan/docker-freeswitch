#!/bin/bash
set -e

mv /etc/freeswitch/vars.xml /tmp/vars.xml.tmpl
envsubst < /tmp/vars.xml.tmpl > /etc/freeswitch/vars.xml
chown -R freeswitch:freeswitch /etc/freeswitch

if [ "$1" = 'freeswitch' ]; then
  setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/freeswitch
  exec chroot --userspec=freeswitch / /usr/bin/freeswitch -u freeswitch -g freeswitch -c -nonat
fi

exec "$@"
