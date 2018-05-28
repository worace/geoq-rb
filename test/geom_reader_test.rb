require "test_helper"
require "json"

module Geoq
  class GeomReaderTest < Minitest::Test
    attr_reader :reader

    def setup
      r,w = IO.pipe
      w.close
      @reader = Geoq::GeomReader.new(r)
    end

    def test_recognizes_geohashes
      assert reader.geohash?("9q5")
      assert reader.geohash?("9Q5")
      assert reader.geohash?(" 9Q5  ")
      refute reader.geohash?(" 9aQ5  ")
      assert reader.geohash?("u58seqshdz50")
    end

    def test_recognizes_geojson
      assert reader.geojson?({type: "Point", coordinates: [0,1]}.to_json)
      refute reader.geojson?("a")
    end

    def test_parse_objects
      parsed = TestData.mixed_stream.to_a
      assert parsed[0].is_a? Geoq::Geohash
      assert parsed[1].is_a? Geoq::GeoJson
      assert parsed[2].is_a? Geoq::Wkt
      assert parsed[3].is_a? Geoq::GeoJson
      assert parsed[4].is_a? Geoq::LatLon
    end

    def test_parsing_lat_lons
      assert reader.latlon?("0,0")
      assert reader.latlon?("0, 0")
      assert reader.latlon?("123.456,98.2")
      assert reader.latlon?("  -123.456,-98.2 ")
    end
  end
end
