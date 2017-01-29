#!/bin/bash

#
# Display settings on standard out.
#

USER="utorrent"
UTORRENT_UID=$PUID
UTORRENT_GID=$PGID

echo "utorrent settings"
echo "================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${UTORRENT_UID}"
echo "  GID:        ${UTORRENT_GID}"
echo

#
# Symlinking webui.zip to settings path.
#

if [[ ! -e /settings/webui.zip ]]
then
    printf 'Symlinking webui.zip to /settings...'
    ln -s /utorrent/webui.zip /settings/webui.zip
    echo "[DONE]"
fi

#
# Finally, start utorrent.
#

echo 'Starting utorrent server...'
exec su -pc "./utserver -settingspath /settings -logfile /settings/utserver.log" ${USER}
