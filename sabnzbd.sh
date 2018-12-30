#!/bin/sh

CONFIG=${CONFIG:=/datadir/sabnzbd.ini}

#
# Because SABnzbd runs in a container we've got to make sure we've got a proper
# listener on 0.0.0.0. We also have to deal with the port which by default is
# 8080 but can be changed by the user.
#

printf "Get listener port... "
PORT=$(sed -n '/^port *=/{s/port *= *//p;q}' ${CONFIG})
LISTENER="-s 0.0.0.0:${PORT:=8080}"
echo "[${PORT}]"

#
# Finally, start SABnzbd.
#

echo "Starting SABnzbd..."
exec su -pc "./SABnzbd.py -b 0 --disable-file-log -f ${CONFIG} ${LISTENER}" sabnzbd