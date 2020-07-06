Next, connect to Materialize in a separate terminal:

`psql -h localhost -p 6875 materialize`{{execute T2}}



## Explore Materialize's API

Materialize offers ANSI Standard SQL, but is not simply a relational database. Instead of tables of data, you typically connect Materialize to external sources of data (called **sources**), and then create materialized views of the data that Materialize sees from those sources.

To get started, though, we'll begin with a simple version that doesn't require connecting to an external data source.

1. From your Materialize CLI, create a materialized view that contains actual data we can work with.

    ```sql
    CREATE MATERIALIZED VIEW mat_view (key, value) AS
        VALUES ('a', 1), ('a', 2), ('a', 3), ('a', 4),
        ('b', 5), ('c', 6), ('c', 7);
    ```{{execute}}

    You'll notice that we end up entering data into Materialize by creating a materialized view from some other data, rather than the typical `INSERT` operation. This is how one interacts with Materialize. In most cases, this data would have come from an external source and get fed into Materialize from a file or a stream.

1. With data in a materialized view, we can perform arbitrary `SELECT` statements on the data.

    Let's start by viewing all of the data:

    ```sql
    SELECT * FROM mat_view;
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

1. Determine the sum of the values for each key:

    ```sql
    SELECT key, sum(value) FROM mat_view GROUP BY key;
    ```{{execute}}
    ```nofmt
     key | sum
    -----+-----
     a   |  10
     b   |   5
     c   |  13
    ```

    We can actually then save this query as its own materialized view:

    ```sql
    CREATE MATERIALIZED VIEW key_sums AS
        SELECT key, sum(value) FROM mat_view GROUP BY key;
    ```{{execute}}

1. Determine the sum of all keys' sums:

    ```sql
    SELECT sum(sum) FROM key_sums;
    ```{{execute}}

1. We can also perform complex operations like `JOIN`s. Given the simplicity of our data, the `JOIN` clauses themselves aren't very exciting, but Materialize offers support for a full range of arbitrarily complex `JOIN`s.

    ```sql
    CREATE MATERIALIZED VIEW lhs (key, value) AS
        VALUES ('x', 'a'), ('y', 'b'), ('z', 'c');
    ```{{execute}}
    ```sql
    SELECT lhs.key, sum(rhs.value)
    FROM lhs
    JOIN mat_view AS rhs
    ON lhs.value = rhs.key
    GROUP BY lhs.key;
    ```{{execute}}

