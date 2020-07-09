#!/usr/bin/env bash

set -euo pipefail

curl -fsSL https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

curl -fsSL http://security.ubuntu.com/ubuntu/pool/main/p/postgresql-10/postgresql-client-10_10.12-0ubuntu0.18.04.1_amd64.deb > postgresql-client.deb
dpkg -i postgresql-client.deb

echo "Installation complete! You can now go ahead and run Materialize:"
echo
echo "    $ materialized -w 1"
echo
