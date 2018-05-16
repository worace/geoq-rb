module GeoCli
  module Commands
    module GeoJson
      class FeatureCollection < Base
        def output
          GeoCli::FeatureCollection.new(instream).to_geojson
        end
      end
    end
  end
end
