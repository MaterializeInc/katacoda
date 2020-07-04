#!/bin/bash

curl -L https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

sudo apt-get update
sudo apt-get install -y postgresql-client
