# todo: no way to for a command to a different term without breaking spacing?

Connect to Materialize
`psql -h localhost -p 6875 materialize`{{execute}}


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