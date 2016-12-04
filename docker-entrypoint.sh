#!/bin/bash
set -e

sed -i 's/$LOCAL_IP_ADDR/'$LOCAL_IP_ADDR'/g' /etc/freeswitch/vars.xml
sed -i 's/$PUBLIC_IP_ADDR/'$PUBLIC_IP_ADDR'/g' /etc/freeswitch/vars.xml
sed -i 's/$EVENT_SOCKET_IP_ADDR/'$EVENT_SOCKET_IP_ADDR'/g' /etc/freeswitch/vars.xml
sed -i 's/$INTERNAL_SIP_PORT/'$INTERNAL_SIP_PORT'/g' /etc/freeswitch/vars.xml
sed -i 's/$EXTERNAL_SIP_PORT/'$EXTERNAL_SIP_PORT'/g' /etc/freeswitch/vars.xml
sed -i 's/$RTP_START_PORT/'$RTP_START_PORT'/g' /etc/freeswitch/vars.xml
sed -i 's/$RTP_END_PORT/'$RTP_END_PORT'/g' /etc/freeswitch/vars.xml
sed -i 's/$EVENT_SOCKET_PORT/'$EVENT_SOCKET_PORT'/g' /etc/freeswitch/vars.xml

if [ "$1" = 'freeswitch' ]; then
  exec gosu freeswitch /usr/bin/freeswitch -u freeswitch -g freeswitch -c -nonat
fi

exec "$@"
