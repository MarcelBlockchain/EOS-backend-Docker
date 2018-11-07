# EOS-BACKEND
eos-backend made by Marcel Morales  

## What it does
* installs a non-producing optimised EOS node using Docker
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
in Docker/ check the .ssh's and config.ini
* replace /mnt/'volume_lon1_01'/mainnet  with /mnt/{your_external_SSD}/mainnet
* create-folders.sh, download-blocks.sh, full-replay.sh, local-replay.sh, restart.sh, config.ini

### Installation

In folder Docker run:

* ```docker build . -t eosio/eos```
* ```docker run -ti --name nodeos -d -p 8888:8888 -p 9876:9876 -p 3838:3838 -v /mnt/{your_external_ssd}/mainnet:/mnt/{your_external_ssd}/mainnet -v /mnt/{your_external_ssd}/mongodb:/mnt/{your_external_ssd}/mongodb -t eosio/eos bash```

install yarn and the node packages  

* ```docker exec -ti nodeos yarn-install.sh  ```

start full replay. Will download all blocks zipped from a Amazon EU webserver, unzip it and start resyncing  

* ```docker exec -ti nodeos full-replay.sh  ```

While syncing blocks you can already start the txAPI via  

* ```docker exec nodeos start-txAPI.sh  ```

To use the terminal insight Docker do  

* ```docker exec -ti nodeos bash  ```

folders worth knowing:
```
/mnt/{your_external_ssd}/mainnet
/mnt/{your_external_ssd}/mongodb
/opt/eosio/bin/
/opt/txAPI/historyapi.js
/bin  // all .ssh files you can access using docker exec ...
```

### docker exec -ti nodeos {.sh}  

downloads and unzips blocks to /mnt/{your_ssd}/mainnet, without resyncing  

* download-blocks.sh

full-replay = download-blocks + local-replay  

* full-replay.sh  

like full-replay but tries to resync using the current blocks folder instead of downloading a new one. If ```'block_log_not_found'```, abort with ^C, cd to ```/mnt/{your_ssd}/mainnet``` and rename ```blocks-2018-10.....``` to ```blocks``` and try again

* local-replay.sh  

stops and restarts the node with best practices, so no 'bad flag' is set which requires to replay  

* restart.sh  

stops nodeos  

* stop.sh  
  
stops and then starts the txAPI  
  
* start-txAPI.sh

* stop-txAPI.sh  

installs yarn and all node packages for txAPI

* yarn-install.sh


### Usage
GET request at
```http://{your_server_IP}:3838/v1/history/get_actions/binancecleos/transfer?blockHeight=0```
where binancecleos can be any EOS account and ```blockHeight``` will ignore all trx below

#### Props and Credits to
Blockmatrix & CryptoLions
