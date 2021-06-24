#!/usr/bin/env bash

set -euo pipefail

pkgs=(
    postgresql-client-common_190ubuntu0.1_all.deb
    libpq5_10.14-0ubuntu0.18.04.1_amd64.deb
    postgresql-client-10_10.14-0ubuntu0.18.04.1_amd64.deb
)

# Prevent package installation from updating the man-db, which is slow.
echo "Configuring system..."
apt-get remove --purge man-db -qy > /dev/null

echo "Installing PostgreSQL..."
for pkg in "${pkgs[@]}"; do
    dpkg -i "/usr/local/dpkg/$pkg"
done

echo "Installing Materialize..."
version=$(curl -fsSL https://materialize.io/docs/versions.json | jq -r .[0].name)
echo "Latest stable release: $version"
curl -fsSL https://binaries.materialize.com/materialized-"$version"-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1

echo "Installation complete! You can now go ahead and run Materialize:"
echo
echo "    $ materialized -w 1"
echo
