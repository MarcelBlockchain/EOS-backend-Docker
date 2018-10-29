#!/bin/bash
db=/mnt/volume_lon1_01/mongodb
m=/opt/eosio/bin/opt/mongod/bin/mongod

if [ ! -d '$db/log' ]; then
        mkdir -v -p $db/log
fi

if [ -f '$db/log/mongod.pid' ]; then
        pid=$(cat $db/log/mongod.pid)
        if [ pgrep -x "mongod" > /dev/null ]; then
          echo "mongod already running with PID: $pid"
          exit
          # couldn't find the right PID inside bash inside Docker to avoid trying to start mongod again and again
          # PR's are welcome
          # -n '$(ps -p $pid -o pid='
          # -n '$pid' -a -e /proc/$pid
          # ps -p $pid > /dev/null
        fi
fi
rm -rf $db/log/mongod.pid
$m --fork --logpath $db/log/mongodb.log --dbpath $db &
echo $! >>$db/log/mongod.pid

echo "mongod PID: $(cat $db/log/mongod.pid)"
