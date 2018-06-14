require "pr_geohash"
require "rgeo"
require "rgeo/geo_json"

module Geoq
  BASE_32 = %w(0 1 2 3 4 5 6 7 8 9 b c d e f g h j
                 k m n p q r s t u v w x y z).join("")
  class GeomReader
    attr_reader :wkt

    GH_REGEX = Regexp.new(/\A[#{BASE_32}]+\z/)

    LAT_LON_REGEX = /\A-?\d+\.?\d*,-?\d+\.?\d*\z/

    include Enumerable

    def initialize(instream)
      @instream = instream
      @wkt = RGeo::WKRep::WKTParser.new
      @factory = RGeo::Cartesian.factory
    end

    def each(&block)
      instream.each_line do |l|
        decode(l).each(&block)
      end
    end

    def decode(line)
      if geohash?(line)
        (lat1, lon1), (lat2, lon2) = GeoHash.decode(line)
        p1 = factory.point(lon1, lat1)
        p2 = factory.point(lon2, lat2)
        geom = RGeo::Cartesian::BoundingBox.create_from_points(p1, p2).to_geometry
        [Geohash.new(geom, strip_whitespace(line))]
      elsif geojson?(line)
        decoded = RGeo::GeoJSON.decode(line)
        case decoded
        when RGeo::GeoJSON::FeatureCollection
          decoded.map { |f| GeoJson.new(f, line) }
        else
          [GeoJson.new(decoded, line)]
        end
      elsif latlon?(line)
        [LatLon.new(factory.point(*(strip_whitespace(line.gsub("\t", ",")).split(",").map(&:to_f).reverse)), line)]
      else
        [Wkt.new(wkt.parse(line), line)]
      end
    end

    def strip_whitespace(line)
      line.gsub(/\s+/, "").downcase
    end

    def geohash?(line)
      !!GH_REGEX.match(strip_whitespace(line))
    end

    def geojson?(line)
      line.lstrip.start_with?("{")
    end

    def latlon?(line)
      !!LAT_LON_REGEX.match(strip_whitespace(line.gsub(/\t/, ",")))
    end

    private

    def instream
      @instream
    end

    def factory
      @factory
    end
  end
end
