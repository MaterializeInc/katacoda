`CREATE MATERIALIZED VIEW pseudo_source (key, value) AS
    VALUES ('a', 1), ('a', 2), ('a', 3), ('a', 4),
    ('b', 5), ('c', 6), ('c', 7);`{{execute}}

`SELECT * FROM pseudo_source;`{{execute}}

`SELECT key, sum(value) FROM pseudo_source GROUP BY key;`{{execute}}

`CREATE MATERIALIZED VIEW key_sums AS
    SELECT key, sum(value) FROM pseudo_source GROUP BY key;`{{execute}}

`SELECT sum(sum) FROM key_sums;`{{execute}}

`CREATE MATERIALIZED VIEW lhs (key, value) AS
    VALUES ('x', 'a'), ('y', 'b'), ('z', 'c');`{{execute}}