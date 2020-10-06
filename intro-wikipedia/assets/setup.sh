#!/usr/bin/env bash

set -euo pipefail

pkgs=(
    p/postgresql-common/postgresql-client-common_190ubuntu0.1_all.deb
    p/postgresql-10/libpq5_10.14-0ubuntu0.18.04.1_amd64.deb
    p/postgresql-10/postgresql-client-10_10.14-0ubuntu0.18.04.1_amd64.deb
)

# Prevent package installation from updating the man-db, which is slow.
apt-get remove --purge man-db -qy

echo "Installing PostgreSQL..."
for pkg in "${pkgs[@]}"; do
    curl -fsSL http://security.ubuntu.com/ubuntu/pool/main/"$pkg" > pkg.deb
    dpkg -i pkg.deb
done

echo "Installing Materialize..."
curl -fsSL https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

echo "Installation complete! You can now go ahead and run Materialize:"
echo
echo "    $ materialized -w 1"
echo
