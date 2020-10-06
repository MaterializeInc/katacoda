#!/usr/bin/env bash

set -euo pipefail

# Prevent package installation from updating the man-db, which is slow.
echo "Configuring system..."
apt-get remove --purge man-db -qy > /dev/null

echo "Installing PostgreSQL..."
for pkg in /usr/local/dpkg/*; do
    dpkg -i "$pkg"
done

echo "Installing Materialize..."
version=$(curl -fsSL https://materialize.io/docs/versions.json | jq -r .[0].name)
echo "Latest stable release: $version"
curl -fsSL https://downloads.mtrlz.dev/materialized-"$version"-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

echo "Installation complete! You can now go ahead and run Materialize:"
echo
echo "    $ materialized -w 1"
echo
