#!/bin/bash
./stop.sh
forever start -a -l forever.log -o out.log -e err.log index.js
