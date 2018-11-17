#!/bin/bash
m=/mnt/volume_lon1_01/mainnet
db=/mnt/volume_lon1_01/mongodb
eos=/opt/eosio/bin

cd /bin
/bin/stop.sh
/bin/create-folders.sh

rm -rf /root/.local/share/eosio/nodeos/data/state

$eos/opt/mongod/bin/mongod --fork --logpath $db/log/mongodb.log --dbpath $db

$eos/nodeos --data-dir $eos/data-dir --config-dir / --mongodb-wipe --hard-replay-blockchain -l $eos/data-dir/logging.json "$@" >> $eos/data-dir/log.txt 2>&1 & echo $! > $eos/data-dir/nodeos.pid

tail -f $eos/data-dir/log.txt
