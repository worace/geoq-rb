require "test_helper"
require "json"

module GeoCli
  class CommandsTest < Minitest::Test
    def test_feature_collection
      fc = GeoCli::Commands::GeoJson::FeatureCollection.new(TestData.mixed_stream)
      json = JSON.parse(fc.output)
      assert_equal "FeatureCollection", json["type"]
      assert_equal ["type", "features"].sort, json.keys.sort
      features = json["features"]
      assert_equal 5, features.count

      # encodes properties
      assert_equal [{}, {}, {}, {"a" => "b"}, {}], features.map { |f| f["properties"] }
      assert_equal Hash.new, features[0]["properties"]
      assert_equal Hash.new, features[1]["properties"]
      assert_equal Hash.new, features[2]["properties"]
      assert_equal({"a" => "b"}, features[3]["properties"])

      assert_equal ["Polygon", "Point", "Point", "Point", "Point"], features.map { |f| f["geometry"]["type"] }

      gh = [[[-119.53125, 33.75], [-118.125, 33.75], [-118.125, 35.15625], [-119.53125, 35.15625], [-119.53125, 33.75]]]
      assert_equal [gh, [0.0,1.0], [1.0, 2.0], [3.0, 4.0], [-118.3, 34.52]], features.map { |f| f["geometry"]["coordinates"] }
    end

    def test_geohash
      input = TestData.stream(["0,0", "34, -118"])
      command = GeoCli::Commands::GeoHash.new(input, {}, {}, ["4"])
      assert_equal ["7zzz", "9qh1"], command.output.to_a
    end

    def test_gh_raises_for_geometry
      input = TestData.mixed_stream.take(1)
      command = GeoCli::Commands::GeoHash.new(input, {}, {}, ["4"])
      assert_raises GeoCli::RepresentationError do
        command.output.to_a
      end
    end
  end
end
