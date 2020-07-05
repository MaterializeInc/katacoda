Install Materialize

----

(These steps are being run for you automatically)

`curl -L https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1`{{execute}}

Install psql
`sudo apt-get update`{{execute}}
`sudo apt-get install -y postgresql-client`{{execute}}

----

Once the installation is complete, run Materialize:
`materialized --w=1`{{execute}}

