```
CREATE MATERIALIZED VIEW pseudo_source (key, value) AS
    VALUES ('a', 1), ('a', 2), ('a', 3), ('a', 4),
    ('b', 5), ('c', 6), ('c', 7);
```{{execute Terminal 2}}

```
SELECT * FROM pseudo_source;
```{{execute Terminal 2}}

`SELECT key, sum(value) FROM pseudo_source GROUP BY key;`{{execute Terminal 2}}

`CREATE MATERIALIZED VIEW key_sums AS
    SELECT key, sum(value) FROM pseudo_source GROUP BY key;`{{execute Terminal 2}}

`SELECT sum(sum) FROM key_sums;`{{execute Terminal 2}}

`CREATE MATERIALIZED VIEW lhs (key, value) AS
    VALUES ('x', 'a'), ('y', 'b'), ('z', 'c');`{{execute Terminal 2}}