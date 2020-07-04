```
while true; do
  curl --max-time 9999999 -N https://stream.wikimedia.org/v2/stream/recentchange >> wikirecent
done
```{{execute T3}}

<pre>
```
CREATE SOURCE wikirecent
FROM FILE '[path to wikirecent]' WITH (tail = true)
FORMAT REGEX '^data: (?P<data>.*)';
```
</pre>

```
CREATE SOURCE wikirecent
FROM FILE '/root/wikirecent' WITH (tail = true)
FORMAT REGEX '^data: (?P<data>.*)';
```{{execute T3}}

```
SHOW COLUMNS FROM wikirecent;
```{{execute T3}}

```
CREATE MATERIALIZED VIEW recentchanges AS
    SELECT
        val->>'$schema' AS r_schema,
        (val->'bot')::bool AS bot,
        val->>'comment' AS comment,
        (val->'id')::float::int AS id,
        (val->'length'->'new')::float::int AS length_new,
        (val->'length'->'old')::float::int AS length_old,
        val->'meta'->>'uri' AS meta_uri,
        val->'meta'->>'id' as meta_id,
        (val->'minor')::bool AS minor,
        (val->'namespace')::float AS namespace,
        val->>'parsedcomment' AS parsedcomment,
        (val->'revision'->'new')::float::int AS revision_new,
        (val->'revision'->'old')::float::int AS revision_old,
        val->>'server_name' AS server_name,
        (val->'server_script_path')::text AS server_script_path,
        val->>'server_url' AS server_url,
        (val->'timestamp')::float AS r_ts,
        val->>'title' AS title,
        val->>'type' AS type,
        val->>'user' AS user,
        val->>'wiki' AS wiki
    FROM (SELECT data::jsonb AS val FROM wikirecent);
```{{execute T3}}