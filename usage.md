# Geoq Usage

```setup
alias geoqqq="bundle exec geoq" &&
```

## GeoJSON (`geoq gj`)

Output a geo feature as a GeoJSON Geometry

```rb
echo 9q5 | bundle exec bin/geoq gj geometry
=> {"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}
```

Output a geo feature as a GeoJSON Feature

```rb
echo 9q5 | bundle exec bin/geoq gj feature
=> {"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}}
```

Combine 1 or more geo features into a GeoJSON Feature Collection

```rb
printf "9q5\n9q4\n" | bundle exec bin/geoq gj fc
=> {"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}},{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-120.9375,33.75],[-119.53125,33.75],[-119.53125,35.15625],[-120.9375,35.15625],[-120.9375,33.75]]]}}]}
```

Converts Geohashes, WKTs, Lat/Lons, and GeoJSON into GeoJSON

```rb
echo 9q5 | bundle exec bin/geoq gj geometry
=> {"type":"Polygon","coordinates":[[[-119.53125,33.75],[-118.125,33.75],[-118.125,35.15625],[-119.53125,35.15625],[-119.53125,33.75]]]}
```

```rb
echo "POINT (1.0 2.0)" | bundle exec bin/geoq gj geometry
=> {"type":"Point","coordinates":[1.0,2.0]}
```

```rb
echo "34.52,-118.3" | bundle exec bin/geoq gj geometry
=> {"type":"Point","coordinates":[-118.3,34.52]}
```

## Geohashes (`geoq gh`)

## WKT (`geoq wkt`)
