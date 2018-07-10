# geoq

[![Gem Version](https://badge.fury.io/rb/geoq.svg)](https://badge.fury.io/rb/geoq)

[![Build Status](https://travis-ci.org/worace/geoq-rb.svg?branch=master)](https://travis-ci.org/worace/geoq-rb)

Geospatial Utility Belt.

## Install

```
gem install geoq
```

## Usage

**[View the Usage Doc](https://github.com/worace/geoq/blob/master/usage.md)** for detailed usage examples.

To view the included help just run the base command:

```
geoq
# or
geoq --help
```

Or view help for a specific command:

```
geoq wkt --help
```

## Feature Wishlist

* [X] Read WKT
* [X] Read GeoJSON
* [X] Read Geohash
* [X] Read Lat,Lon
* [X] Output GeoJSON geom
* [X] Output GeoJSON feature
* [X] Output GeoJSON featurecollection
* [X] Output geohash (point)
* [ ] Output geohashes (geometry -- covering geohashes)
* [ ] Output Geom Centroid
* [ ] Output Geom area
* [ ] Output Geom perimeter
* [X] Output Geohash Children
* [X] Output Geohash Neighbors
* [ ] Output results to gist (geojson only)
* [X] Literate-style Usage doc with checked examples

## Releasing

```
gem build geoq.gemspec
gem push geoq-*.gem
rm geoq-*.gem
```
