#!/bin/bash
db=/mnt/volume_lon1_01/mongodb
eos=/opt/eosio/bin

cd /bin

/bin/create-folders.sh
$eos/opt/mongod/bin/mongod --fork --logpath $db/log/mongodb.log --dbpath $db
/bin/build_indexes.sh
