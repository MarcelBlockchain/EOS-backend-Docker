#!/bin/sh
cd /opt/eosio/bin

if [ ! -d "/opt/eosio/bin/data-dir" ]; then
    mkdir /opt/eosio/bin/data-dir
fi

if [ -f '/opt/eosio/bin/data-dir/config.ini' ]; then
    echo
  else
    cp /config.ini /opt/eosio/bin/data-dir
fi

if [ -d '/opt/eosio/bin/data-dir/contracts' ]; then
    echo
  else
    cp -r /contracts /opt/eosio/bin/data-dir
fi

while :; do
    case $1 in
        --config-dir=?*)
            CONFIG_DIR=${1#*=}
            ;;
        *)
            break
    esac
    shift
done

if [ ! "$CONFIG_DIR" ]; then
    CONFIG_DIR="--config-dir=/opt/eosio/bin/data-dir"
else
    CONFIG_DIR=""
fi

exec /opt/eosio/bin/stop.sh
cd /mnt/volume_lon1_01/mainnet
wget $(wget --quiet "https://eosnode.tools/api/blocks?limit=1" -O- | jq -r '.data[0].s3') -O blocks_backup.tar.gz
rm -rf blocks /root/.local/share/eosio/nodeos/data/state
tar xvzf blocks_backup.tar.gz

exec mkdir -p /mnt/volume_lon1_01/mongodb/log && /opt/eosio/bin/opt/mongod/bin/mongod --fork --logpath /mnt/volume_lon1_01/mongodb/log/mongodb.log --dbpath /mnt/volume_lon1_01/mongodb

exec /opt/eosio/bin/nodeos --data-dir /opt/eosio/bin/data-dir --config-dir /config.ini -l /opt/eosio/bin/data-dir/logging.json "$@" >> /opt/eosio/bin/data-dir/log.txt 2>&1 & echo $! > /opt/eosio/bin/data-dir/nodeos.pid
