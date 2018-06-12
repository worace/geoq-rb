$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "geoq"

require "minitest/autorun"
require "minitest/reporters"
require "minitest/spec"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

module Geoq::TestData
  def self.stream(strings)
    r,w = IO.pipe
    strings.each do |s|
      w.puts(s)
    end
    w.close
    Geoq::GeomReader.new(r)
  end

  def self.mixed_stream
    inputs = ["9q5",
              {type: "Point", coordinates: [0,1]}.to_json,
              "POINT (1.0 2.0)",
              {type: "Feature", properties: {a: "b"}, geometry: {type: "Point", coordinates: [3,4]}}.to_json,
              "34.52,-118.3",
              {type: "FeatureCollection", features: [{type: "Feature", properties: {a: "b"}, geometry: {type: "Point", coordinates: [3,4]}}]}.to_json]
    stream(inputs)
  end
end
