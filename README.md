# EOS-BACKEND
eos-backend made by Marcel Morales  

## What it does
* installs a non-producing EOS node using Docker
* saves all transactions in separate mongodb
* public API to query this mongodb
* public API to create EOS-accounts remotely
    * just send 'acc-name' and currency to pay [BTC, ETH, EOS]
* all in one Docker container

## Manual

#### Assumption
Have a basic server running. E.g a Digital Ocean droplet 18.04, 4 standard CPU cores, 16GB RAM (minimum), 160GB + extra 500GB XFS (!) storage  
Stronger CPU means faster syncing
* [Initial Server Setup Digital Ocean Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04) Step 5 not needed, just follow:
* [How to Set Up SSH Keys on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1804)

### Change following variables
in Docker/ check the .ssh's and
* replace /mnt/'volume_lon1_01'/mainnet  with /mnt/{your_external_SSD}/mainnet as well as in config.ini
* exact files tba

### Installation

In folder Docker run:

* docker build . -t eosio/eos
* docker run -ti --name nodeos -d -p 8888:8888 -p 9876:9876 -p 3838:3838 -v /mnt/{your_external_ssd}/mainnet:/mnt/{your_external_ssd}/mainnet -t eosio/eos bash
* docker exec -ti nodeos full-replay.sh
While syncing blocks you can already start the txAPI via
* docker exec nodeos start-txAPI.sh

To use the terminal insight Docker do
* docker exec -ti nodeos bash

folders worth knowing:
```
/mnt/{your_external_ssd}/mainnet
/mnt/{your_external_ssd}/mongodb
/opt/eosio/bin/
/opt/txAPI/
/bin  // all .ssh files you can access using docker exec ...
```

### Usage
GET request at
http://{your_server_IP}:3838/v1/history/get_actions/binancecleos/transfer?blockHeight=0  
where binancecleos can be any EOS account and blockHeight will ignore all trx below

#### Props and Credits to
Blockmatrix & CryptoLions
