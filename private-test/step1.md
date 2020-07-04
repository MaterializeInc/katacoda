Install Materialize

`curl -L https://downloads.mtrlz.dev/materialized-v0.3.1-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xzC /usr/local --strip-components=1`{{execute}}

Install psql
`sudo apt-get update`{{execute}}
`sudo apt-get install -y postgresql-client`{{execute}}


Run Materialize
`materialized --w=1`{{execute}}

Connect to Materialize
`psql -h localhost -p 6875 materialize`{{execute}}

