Next, connect to Materialize in a separate terminal:

`psql -h localhost -p 6875 materialize`{{execute T2}}

## Explore Materialize's API

Materialize offers ANSI Standard SQL, but is not simply a relational database. Instead of tables of data, you typically connect Materialize to external sources of data (called **sources**), and then create materialized views of the data that Materialize sees from those sources.

To get started, though, we'll begin with a simple version that doesn't require connecting to an external data source.

1. From your Materialize CLI, create a materialized view that contains actual data we can work with.

    ```sql
    CREATE MATERIALIZED VIEW pseudo_source (key, value) AS
        VALUES ('a', 1), ('a', 2), ('a', 3), ('a', 4),
        ('b', 5), ('c', 6), ('c', 7);
    ```{{execute}}

    You'll notice that we end up entering data into Materialize by creating a materialized view from some other data, rather than the typical `INSERT` operation. This is how one interacts with Materialize. In most cases, this data would have come from an external source and get fed into Materialize from a file or a stream.

1. With data in a materialized view, we can perform arbitrary `SELECT` statements on the data.

    Let's start by viewing all of the data:

    ```sql
    SELECT * FROM pseudo_source;
    ```{{execute}}

    ```nofmt
     key | value
    -----+-------
     a   |     1
     a   |     2
     a   |     3
     a   |     4
     b   |     5
     c   |     6
     c   |     7
    ```





```
CREATE MATERIALIZED VIEW pseudo_source (key, value) AS
    VALUES ('a', 1), ('a', 2), ('a', 3), ('a', 4),
    ('b', 5), ('c', 6), ('c', 7);
```{{execute}}

`SELECT * FROM pseudo_source;`{{execute}}

`SELECT key, sum(value) FROM pseudo_source GROUP BY key;`{{execute T2}}

```
CREATE MATERIALIZED VIEW key_sums AS
    SELECT key, sum(value) FROM pseudo_source GROUP BY key;
```{{execute}}

```
SELECT sum(sum) FROM key_sums;
```{{execute}}


```
CREATE MATERIALIZED VIEW lhs (key, value) AS
    VALUES ('x', 'a'), ('y', 'b'), ('z', 'c');
```{{execute}}

```
SELECT lhs.key, sum(rhs.value)
FROM lhs
JOIN pseudo_source AS rhs
ON lhs.value = rhs.key
GROUP BY lhs.key;
```{{execute}}