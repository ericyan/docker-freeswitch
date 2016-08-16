#!/bin/bash
set -e

if [ "$1" = 'freeswitch' ]; then
  exec gosu freeswitch /usr/bin/freeswitch -u freeswitch -g freeswitch -c -nonat
fi

exec "$@"
