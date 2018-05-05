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
echo "POINT (1.0 2.0)" | geo-cli gj
=> {"type":"Point","coordinates":[1,2]}
```

geohash to geojson/wkt

```
echo 9q5 | geo-cli gj
=> {"type":"Point","coordinates":[1,2]}
```
