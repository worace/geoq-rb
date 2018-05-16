require "rgeo/geo_json"
require "pr_geohash"
require "rgeo"

module GeoCli
  class Entity
    attr_reader :entity, :raw

    def initialize(entity, raw)
      @entity = entity
      @raw = raw
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

    def gh_string(level)
      if entity.dimension == 0
        GeoHash.encode(entity.x, entity.y, level)
      else
        raise RepresentationError.new("GeoHash representation not supported for #{entity.to_s}")
      end
    end

    def gh_children
      raise RepresentationError.new("GeoHash children not supported for #{entity.to_s}")
    end
  end

  class Geohash < Entity
    def gh_children
      BASE_32.chars.map { |char| raw + char }
    end
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
end
