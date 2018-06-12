require "test_helper"
require "json"

module Geoq
  class CommandsTest < Minitest::Test
    def reader
      i,o = IO.pipe
      o.close
      GeomReader.new(i)
    end

    def test_decoding_returns_list_of_features
      gh = reader.decode("9q").first
      assert_equal({"type"=>"Polygon", "coordinates"=>[[[-123.75, 33.75], [-112.5, 33.75], [-112.5, 39.375], [-123.75, 39.375], [-123.75, 33.75]]]}, gh.as_geojson)

      assert_equal 1, reader.decode("9q").count
      assert_equal 1, reader.decode("1,2").count
      assert_equal 2, reader.decode(TestData.fc.to_json).count
    end
  end
end
