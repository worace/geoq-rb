require "pr_geohash"
require "rgeo"
require "rgeo/geo_json"

module GeoCli
  module Commands
    class Base
      attr_reader :global_opts, :opts, :args, :instream
      def initialize(instream, global_opts = {}, opts = {}, args = [])
        @global_opts = global_opts
        @opts = opts
        @args = args
        @instream = instream
      end

      def output
        raise "Not implemented"
      end
    end

    module GeoJson
      class FeatureCollection < Base
        def output
          GeoCli::FeatureCollection.new(instream).to_geojson
        end
      end
    end
  end

  class Entity
    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    def as_geojson(feature = false)
      geom = RGeo::GeoJSON.encode(entity)
      if feature
        {type: "Feature",
         properties: {},
         geometry: geom}
      else
        geom
      end
    end

    def to_geojson(feature = false)
      as_geojson(feature).to_json
    end

    def to_wkt
      entity.as_text
    end
  end

  class Geohash < Entity
  end

  class Wkt < Entity
  end

  class LatLon < Entity
  end

  class GeoJson < Entity
    def as_geojson(feature = false)
      if feature
        if entity.is_a?(RGeo::GeoJSON::Feature)
          RGeo::GeoJSON.encode(entity)
        else
          {type: "Feature",
           properties: {},
           geometry: RGeo::GeoJSON.encode(entity)}
        end
      else
        RGeo::GeoJSON.encode(entity)
      end
    end
  end

  class FeatureCollection
    attr_reader :entities
    def initialize(entities)
      @entities = entities
    end

    def to_geojson
      {type: "FeatureCollection",
       features: entities.map { |e| e.as_geojson(true) } }.to_json
    end
  end

  class GeomReader
    attr_reader :wkt

    BASE_32 = %w(0 1 2 3 4 5 6 7 8 9 b c d e f g h j
                 k m n p q r s t u v w x y z).flat_map { |c| [c, c.upcase].uniq }.join("")
    GH_REGEX = Regexp.new(/\A\s*[#{BASE_32}]+\s*\z/)

    LAT_LON_REGEX = /\A-?\d+\.?\d*,-?\d+\.?\d*\z/

    include Enumerable

    def initialize(instream)
      @instream = instream
      @wkt = RGeo::WKRep::WKTParser.new
      @factory = RGeo::Cartesian.factory
    end

    def each(&block)
      instream.each_line do |l|
        block.call(decode(l))
      end
    end

    def decode(line)
      if geohash?(line)
        (lat1, lon1), (lat2, lon2) = GeoHash.decode(line)
        p1 = factory.point(lon1, lat1)
        p2 = factory.point(lon2, lat2)
        geom = RGeo::Cartesian::BoundingBox.create_from_points(p1, p2).to_geometry
        Geohash.new(geom)
      elsif geojson?(line)
        GeoJson.new(RGeo::GeoJSON.decode(line))
      elsif latlon?(line)
        LatLon.new(factory.point(*line.split(",").map(&:to_f)))
      else
        Wkt.new(wkt.parse(line))
      end
    end

    def geohash?(line)
      !!GH_REGEX.match(line)
    end

    def geojson?(line)
      line.lstrip.start_with?("{")
    end

    def latlon?(line)
      !!LAT_LON_REGEX.match(line.gsub(/\s+/, ""))
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
