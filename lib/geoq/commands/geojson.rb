module Geoq
  module Commands
    module GeoJson
      class FeatureCollection < Base
        def output
          Geoq::FeatureCollection.new(instream).to_geojson
        end
      end
    end
  end
end
