# Geoq Usage

## Generating GeoJSON (`geoq gj`)

Output a geo feature as a GeoJSON Geometry

```example
echo 9q5 | geoq gj geometry
=> {"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}
```

Output a geo feature as a GeoJSON Feature

```example
echo 9q5 | geoq gj feature
=> {"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}}
```

Combine 1 or more geo features into a GeoJSON Feature Collection

```example
printf "9q5\n9q4\n" | geoq gj fc
=> {"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-120.9375,33.75],[-119.53125,33.75],[-119.53125,35.15625],[-120.9375,35.15625],[-120.9375,33.75]]]}}]}
```

Concat multiple GeoJSON Feature Collections into a single collection

```example
printf "9q5\n{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}},{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-120.9375,33.75],[-119.53125,33.75],[-119.53125,35.15625],[-120.9375,35.15625],[-120.9375,33.75]]]}}]}" | geoq gj fc | jq ".features | length"
=> 3
```

Converts Geohashes, WKTs, Lat/Lons, and GeoJSON into GeoJSON

```example
echo 9q5 | geoq gj geometry
=> {"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}
```

```example
echo "POINT (1.0 2.0)" | geoq gj geometry
=> {"type":"Point","coordinates":[1.0,2.0]}
```

```example
echo "34.52,-118.3" | geoq gj geometry
=> {"type":"Point","coordinates":[-118.3,34.52]}
```

```example
echo '{"type":"Point","coordinates":[-118.3,34.52]}' | geoq gj geometry
=> {"type":"Point","coordinates":[-118.3,34.52]}
```

## Working with Geohashes (`geoq gh`)

Convert a point to a geohash at specified level

```example
echo "34,-118" | geoq gh point 4
=> 9qh1
```

Get children of a geohash

```example
echo 9qh1 | geoq gh children
=> 9qh10
9qh11
9qh12
9qh13
9qh14
9qh15
9qh16
9qh17
9qh18
9qh19
9qh1b
9qh1c
9qh1d
9qh1e
9qh1f
9qh1g
9qh1h
9qh1j
9qh1k
9qh1m
9qh1n
9qh1p
9qh1q
9qh1r
9qh1s
9qh1t
9qh1u
9qh1v
9qh1w
9qh1x
9qh1y
9qh1z
```

Get neighbors of a geohash

```example
echo 9qh1 | geoq gh neighbors
=> 9qh4
9qh6
9qh3
9qh2
9qh0
9q5b
9q5c
9q5f
```

Include the original geohash in the neighbors list:

```example
echo 9qh1 | geoq gh neighbors -i
=> 9qh1
9qh4
9qh6
9qh3
9qh2
9qh0
9q5b
9q5c
9q5f
```

## Generating WKT (`geoq wkt`)

Converts Geohashes, WKTs, Lat/Lons, and GeoJSON into GeoJSON

```example
echo 9q5 | geoq wkt
=> POLYGON ((-119.53125 33.75, -118.125 33.75, -118.125 35.15625, -119.53125 35.15625, -119.53125 33.75))
```

```example
echo "POINT (1.0 2.0)" | geoq wkt
=> POINT (1.0 2.0)
```

```example
echo "34.52,-118.3" | geoq wkt
=> POINT (-118.3 34.52)
```

```example
echo '{"type":"Point","coordinates":[-118.3,34.52]}' | geoq wkt
=> POINT (-118.3 34.52)
```
