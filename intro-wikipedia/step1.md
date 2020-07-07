Materialize is a streaming database for real-time applications. Materialize accepts input data from a variety of streaming sources (e.g. Kafka) and files (e.g. CSVs), and lets you query them using SQL.

To help you get started with Materialize, we'll:

- Install, run, and connect to Materialize
- Explore its API
- Set up a real-time stream to perform aggregations on

## Install Materialize

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

**Pro-tip:** clicking on a command will run it automatically for you in Katacoda!

