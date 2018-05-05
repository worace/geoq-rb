require "pr_geohash"
require "rgeo"
require "rgeo/geo_json"

module GeoCli
  class GeomReader
    attr_reader :wkt

    BASE_32 = %w(0 1 2 3 4 5 6 7 8 9 b c d e f g h j
                 k m n p q r s t u v w x y z).flat_map { |c| [c, c.upcase].uniq }.join("")
    GH_REGEX = Regexp.new(/\A\s*[#{BASE_32}]+\s*\z/)

    include Enumerable

    def initialize(instream)
      @instream = instream
      @wkt = RGeo::WKRep::WKTParser.new
    end

    def each(&block)
      instream.each_line do |l|
        block.call(decode(l))
      end
    end

    def decode(line)
      if geohash?(line)
        GeoHash.decode(line)
      elsif geojson?(line)
        RGeo::GeoJSON.decode(line)
      else
        wkt.parse(line)
      end
    end

    def geohash?(line)
      !!GH_REGEX.match(line)
    end

    def geojson?(line)
      line.lstrip.start_with?("{")
    end

    private

    def instream
      @instream
    end
  end
end
