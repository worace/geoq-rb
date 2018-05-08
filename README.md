# geo-cli

Geospatial Utility Belt.

## (desired) Features

Geojson to wkt

```
echo '{"type":"Point","coordinates":[1,2]}' | geo-cli wkt
=> "POINT (1.0 2.0)"
```

wkt to geojson

```
echo "POINT (1.0 2.0)" | geo-cli gj geometry
=> {"type":"Point","coordinates":[1,2]}
```

geohash to geojson/wkt

```
echo 9q5 | geo-cli gj geometry
=> {"type":"Point","coordinates":[1,2]}
```

geojson feature

```
echo 9q5 | geo-cli gj feature
=> {"type": "Feature", "properties": {}, "geometry": {"type":"Point","coordinates":[1,2]}}
```

geojson feature collection (??)

```
echo 9q5 | geo-cli gj fc
=> {"type": "FeatureCollection", "features": [{"type": "Feature", "properties": {}, "geometry": {"type":"Point","coordinates":[1,2]}}]}
```

slurp multiple geoms into feature collection

```
printf "9q5\n9q6\n9q7\n" | geo-cli gj fc
=> {"type": "FeatureCollection", "features": [...]}
```

post gist to github

```
echo 9q5 | geo-cli gj | geo-cli gist
=> {"type":"Point","coordinates":[1,2]}
```
Geohash Ops

* Covering Geohashes
* Children
* Neighbors
