#!/bin/bash
m=/mnt/volume_lon1_01/mainnet
eos=/opt/eosio/bin

cd /bin
/bin/stop.sh
/bin/create-folders.sh

rm -rf $m/blocks /root/.local/share/eosio/nodeos/data/state
wget $(wget "https://eosnode.tools/api/blocks?limit=1" -O- | jq -r '.data[0].s3') -O $m/blocks_backup.tar.gz

tar xvzf $m/blocks_backup.tar.gz -C $m
