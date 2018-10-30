#!/bin/bash
m=/mnt/volume_lon1_01/mainnet
db=/mnt/volume_lon1_01/mongodb
eos=/opt/eosio/bin

./stop.sh
./create-folders.sh
$eos/opt/mongod/bin/mongod --fork --logpath $db/log/mongodb.log --dbpath $db

$eos/nodeos --data-dir $eos/data-dir --config-dir / -l $eos/data-dir/logging.json "$@" >> $eos/data-dir/log.txt 2>&1 & echo $! > $eos/data-dir/nodeos.pid

tail -f $eos/data-dir/log.txt
