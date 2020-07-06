## Create a real-time stream

Materialize is built to handle streams of data, and provide incredibly low-latency answers to queries over that data. To show off that capability, in this section we'll set up a real-time stream, and then see how Materialize lets you query it.

1. We'll set up a stream of Wikipedia's recent changes, and simply write all data that we see to a file.

    From your shell, run in a new terminal:
    ```
    while true; do
      curl --max-time 9999999 -N https://stream.wikimedia.org/v2/stream/recentchange >> wikirecent
    done
    ```{{execute T3}}

    Note the absolute path of the location where you write `wikirecent`, which we'll need in the next step.

1. From within the CLI, create a source from the `wikirecent` file:

    ```sql
    CREATE SOURCE wikirecent
    FROM FILE '/root/wikirecent' WITH (tail = true)
    FORMAT REGEX '^data: (?P<data>.*)';
    ```{{execute T2}}

    (We've filled in the path to wikirecent for you as "/root/wikirecent")

    This source takes the lines from the stream, finds those that begins with `data:`, and then captures the rest of the line in a column called `data`

    You can see the columns that get generated for this source:

    ```sql
    SHOW COLUMNS FROM wikirecent;
    ```{{execute T2}}

1. Because this stream comes in as JSON, we'll need to normalize the data to perform aggregations on it. Materialize offers the ability to do this easily using our built-in [`jsonb` functions](https://materialize.io/docs/sql/functions/#json).

    ```sql
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
    ```{{execute T2}}

1. For the next steps, let's first turn on timing, which displays the runtime of each SQL command.

    ```sql
    \timing
    ```{{execute T2}}

1. From our view we can start building our aggregations. The simplest place to start is simply counting the number of items we've seen:

    ```sql
    SELECT COUNT(*) FROM recentchanges;
    ```{{execute T2}}

1. This is fast, but over time, as our data grows, this will get
slower. If we want to return to this result, we can tell Materialize
to keep this value updated by creating a materialized view:

    ```sql
    CREATE MATERIALIZED VIEW counter AS
        SELECT COUNT(*) FROM recentchanges;
    ```{{execute T2}}

1. Now, selecting from this materialized view is much faster:

   ```sql
   SELECT * FROM counter;
   ```{{execute T2}}

1. We can also see more interesting things from our stream. For instance, who are making the most changes to Wikipedia?

    ```sql
    CREATE MATERIALIZED VIEW useredits AS
        SELECT user, count(*) FROM recentchanges GROUP BY user;
    ```{{execute T2}}

    ```sql
    SELECT * FROM useredits ORDER BY count DESC;
    ```{{execute T2}}
    (hit 'q' to exit a paginated query)

1. We can also create new views downstream of existing views, for instance, if we are interested in a top 10 leaderboard:

    ```sql
    CREATE MATERIALIZED VIEW top10 AS
        SELECT * FROM useredits ORDER BY count DESC LIMIT 10;
    ```{{execute T2}}

    We can then quickly get the answer to who the top 10 editors are:

    ```sql
    SELECT * FROM top10 ORDER BY count DESC;
    ```{{execute T2}}

Naturally, there are many interesting views of this data. If you're
interested in continuing to explore it, you can check out the stream's
documentation [from
Wikipedia](https://stream.wikimedia.org/?doc#/Streams/get_v2_stream_recentchange).


Next, [see how Materialize can work as an entire microservices →](https://materialize.io/docs/demos/microservice/)
