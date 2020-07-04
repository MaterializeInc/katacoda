```
while true; do
  curl --max-time 9999999 -N https://stream.wikimedia.org/v2/stream/recentchange >> wikirecent
done
```{{execute Terminal 3}}

