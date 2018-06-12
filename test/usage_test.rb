require "test_helper"

module Geoq
  class UsageTest < Minitest::Test
    def self.script_setup
      File.read("./usage.md").match(/```setup\n(.+)\n```/)[1]
    end

    def self.examples
      File.read("./usage.md").scan(/```example\n(.*?)```\n/m).to_a.flatten.map { |match| match.split("\n=> ") }
    end

    def self.checked_command(command)
      result = `#{command.gsub("geoq", "bundle exec bin/geoq")}`
      if $? != 0
        raise RuntimeError.new("Command #{command} exited with non-zero response code.")
      end
      result
    end

    examples.each_with_index do |(command, expected_output), index|
      define_method("test_#{index}") do
        result = self.class.checked_command(command)
        assert_equal expected_output, result, "Checked example: #{command} failed"
      end
    end

    def test_reads_examples
      assert_equal 16, self.class.examples.count
    end
  end
end
