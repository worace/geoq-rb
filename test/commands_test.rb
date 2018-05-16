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

    def test_geohash_point
      input = TestData.stream(["0,0", "34, -118"])
      command = GeoCli::Commands::GeoHash::Point.new(input, {}, {}, ["4"])
      assert_equal ["7zzz", "9qh1"], command.output.to_a
    end

    def test_gh_point_raises_for_geometry
      input = TestData.mixed_stream.take(1)
      command = GeoCli::Commands::GeoHash::Point.new(input, {}, {}, ["4"])
      assert_raises GeoCli::RepresentationError do
        command.output.to_a
      end
    end

    def test_geohash_children
      input = TestData.stream(["9q"])
      command = GeoCli::Commands::GeoHash::Children.new(input)
      children = ["9q0", "9q1", "9q2", "9q3", "9q4", "9q5", "9q6",
                  "9q7", "9q8", "9q9", "9qb", "9qc", "9qd", "9qe",
                  "9qf", "9qg", "9qh", "9qj", "9qk", "9qm", "9qn",
                  "9qp", "9qq", "9qr", "9qs", "9qt", "9qu", "9qv",
                  "9qw", "9qx", "9qy", "9qz"]
      assert_equal children, command.output.to_a
    end

    def test_geohash_children_raises_for_other_geoms
      TestData.mixed_stream.reject do |entity|
        entity.is_a?(Geohash)
      end.each do |i|
        s = TestData.stream([i.raw])
        command = GeoCli::Commands::GeoHash::Children.new(s)
        assert_raises GeoCli::RepresentationError do
          command.output.to_a
        end
      end
    end
  end
end