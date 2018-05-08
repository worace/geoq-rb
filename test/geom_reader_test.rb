require "test_helper"
require "json"

class TestGeomReader < Minitest::Test
  attr_reader :reader

  def setup
    r,w = IO.pipe
    w.close
    @reader = GeoCli::GeomReader.new(r)
  end

  def stream(strings)
    r,w = IO.pipe
    strings.each do |s|
      w.puts(s)
    end
    w.close
    GeoCli::GeomReader.new(r)
  end

  def mixed_stream
    inputs = ["9q5",
              {type: "Point", coordinates: [0,1]}.to_json,
              "POINT (1.0 2.0)",
              {type: "Feature", properties: {a: "b"}, geometry: {type: "Point", coordinates: [3,4]}}.to_json]
    stream(inputs)
  end

  def test_recognizes_geohashes
    assert @reader.geohash?("9q5")
    assert @reader.geohash?("9Q5")
    assert @reader.geohash?(" 9Q5  ")
    refute @reader.geohash?(" 9aQ5  ")
    assert @reader.geohash?("u58seqshdz50")
  end

  def test_recognizes_geojson
    assert @reader.geojson?({type: "Point", coordinates: [0,1]}.to_json)
    refute @reader.geojson?("a")
  end

  def test_parse_objects
    parsed = mixed_stream.to_a
    assert parsed[0].is_a? GeoCli::Geohash
    assert parsed[1].is_a? GeoCli::GeoJson
    assert parsed[2].is_a? GeoCli::Wkt
    assert parsed[3].is_a? GeoCli::GeoJson
  end

  def test_feature_collection
    fc = GeoCli::Commands::GeoJson::FeatureCollection.new(mixed_stream)
    json = JSON.parse(fc.output)
    assert_equal "FeatureCollection", json["type"]
    assert_equal ["type", "features"].sort, json.keys.sort
    features = json["features"]
    assert_equal 4, features.count

    # encodes properties
    assert_equal [{}, {}, {}, {"a" => "b"}], features.map { |f| f["properties"] }
    assert_equal Hash.new, features[0]["properties"]
    assert_equal Hash.new, features[1]["properties"]
    assert_equal Hash.new, features[2]["properties"]
    assert_equal({"a" => "b"}, features[3]["properties"])

    assert_equal ["Polygon", "Point", "Point", "Point"], features.map { |f| f["geometry"]["type"] }

    gh = [[[-119.53125, 33.75], [-118.125, 33.75], [-118.125, 35.15625], [-119.53125, 35.15625], [-119.53125, 33.75]]]
    assert_equal [gh, [0.0,1.0], [1.0, 2.0], [3.0, 4.0]], features.map { |f| f["geometry"]["coordinates"] }
  end
end
