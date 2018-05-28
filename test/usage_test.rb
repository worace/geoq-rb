require "test_helper"

module Geoq
  class UsageTest < Minitest::Test
    def script_setup
      File.read("./usage.md").match(/```setup\n(.+)\n```/)[1]
    end

    def examples
      File.read("./usage.md").scan(/```example\n(.*?)```\n/m).to_a.flatten.map { |match| match.split("\n=> ") }
    end

    def setup
    end

    def test_reads_examples
      assert_equal 15, examples.count
    end

    def checked_command(command)
      result = `#{command.gsub("geoq", "bundle exec bin/geoq")}`
      if $? != 0
        raise RuntimeError.new("Command #{command} exited with non-zero response code.")
      end
      result
    end

    def test_run_examples
      examples.each do |command, expected_output|
        result = checked_command(command)
        assert_equal expected_output, result, "Checked example: #{command} failed"
      end
    end
  end
end
