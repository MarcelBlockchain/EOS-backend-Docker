#!/bin/bash
################################################################################
#
# Clean stop of nodeos (unchanged since the Jungle testnet days!)
#
################################################################################

DIR=/opt/eosio/bin/data-dir

if [ -f $DIR"/nodeos.pid" ]; then
    pid=$(cat $DIR"/nodeos.pid")
    echo $pid
    kill $pid

    if [ $? -ne 0 ]; then
        exit 1
    fi

    rm -r $DIR"/nodeos.pid"

    echo -ne "Stopping Nodeos"

    while true; do
        [ ! -d "/proc/$pid/fd" ] && break
        echo -ne "."
        sleep 1
    done
    echo -ne "\rNodeos stopped. \n"
fi
