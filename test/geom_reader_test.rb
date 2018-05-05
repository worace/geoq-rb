require "test_helper"
require "json"

class TestGeomReader < Minitest::Test
  attr_reader :reader

  def setup
    r,w = IO.pipe
    w.close
    @reader = GeoCli::GeomReader.new(r)
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
    inputs = ["9q5",
              {type: "Point", coordinates: [0,1]}.to_json,
              "POINT (1.0 2.0)"]
    parsed = make_reader(inputs).to_a
    assert_equal [[33.75, -119.53125], [35.15625, -118.125]], parsed[0]
    assert parsed[1].is_a?(RGeo::Geos::CAPIPointImpl)
    assert parsed[2].is_a?(RGeo::Geos::CAPIPointImpl)
  end

  def make_reader(strings)
    r,w = IO.pipe
    strings.each do |s|
      w.puts(s)
    end
    w.close
    GeoCli::GeomReader.new(r)
  end
end
