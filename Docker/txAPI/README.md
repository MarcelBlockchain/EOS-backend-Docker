# EOS-BACKEND
eos-backend made by Marcel Morales  
using [eosjs](https://github.com/EOSIO/eosjs), [automated EOS installation](https://github.com/BlockMatrixNetwork/eos-mainnet) by BlockMatrix and Docker

## What it does
* installs a non-producing EOS node using [automated EOS installation](https://github.com/BlockMatrixNetwork/eos-mainnet) by BlockMatrix
* saves all transactions and action traces in separate mongodb
* public API to query this mongodb
* public API to create EOS-accounts remotely
    * just send 'acc-name' and currency to pay [BTC, ETH, EOS]
* all in one Docker container

## Manual

#### Assumption
Have a basic server running. E.g a Digital Ocean droplet 18.04, 4 standard CPU cores, 8GB RAM (minimum), 160GB + extra 500GB XFS (!) storage  
Stronger CPU means faster syncing
* [Initial Server Setup Digital Ocean Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04) Step 5 not needed, just follow:
* [How to Set Up SSH Keys on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1804)

### Change following variables
* `eosbackend/eos-mainnet/group-vars/mainnet.yml`
    * `agent_name` if wished  
    * `eos_install_dir`, `mainnet_install_dir` and `ansible_ssh_private_key_file`. Replace `volume_lon1_01` with the name of your XFS formatted volume mounted at `/mnt/`  
* Same for `eos-mainnet/roles/network/templates/mainnet/api.j2` 
    * L12 `blocks-dir`  
* `eos-mainnet/inventory`
    *  replace the IP with your server's

### Installation

In folder Docker run:

* docker build -t eosnode/eosio:1.0 .
* docker run -ti -d -v /mnt/{your_XFS_volume_here}:/mnt/{your_XFS_volume_here} --rm eosnode/eosio:1.0 /bin/sh
* cd /home/eosbackend/eos-mainnet && ansible-playbook install yml
* wait 30-60min

... to be continued ...

#### Helpful links
https://eosnode.tools/

#### Props and Credits to
Blockmatrix & CryptoLions