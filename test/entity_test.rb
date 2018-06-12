require "test_helper"
require "json"

module Geoq
  class CommandsTest < Minitest::Test
    def reader
      i,o = IO.pipe
      o.close
      GeomReader.new(i)
    end
    def test_as_geojson_returns_collection
      gh = reader.decode("9q")
      assert_equal({"type"=>"Polygon", "coordinates"=>[[[-123.75, 33.75], [-112.5, 33.75], [-112.5, 39.375], [-123.75, 39.375], [-123.75, 33.75]]]}, gh.as_geojson)
      assert_equal [gh], gh.to_a
    end
  end
end
