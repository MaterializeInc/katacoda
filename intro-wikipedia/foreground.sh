#!/bin/bash

curl -L https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

# todo: move this to foreground for step2?
sudo apt-get update

sudo apt-get install -y postgresql-client && echo "Installation complete! You can now go ahead and run Materialize: " && echo "   materialized --w=1  "

