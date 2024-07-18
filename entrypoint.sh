#!/bin/bash

if [ -e /scripts/init.sh ]; then
    /scripts/init.sh
fi;

exec /usr/bin/dumb-init -- /opt/exabgp/sbin/exabgp "${@}"
