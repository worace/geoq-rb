module GeoCli
  module Commands
    class GeoHash < Base
      def level
        args.first.to_i
      end

      def output
        Enumerator.new do |e|
          instream.each do |entity|
            e << entity.gh_string(level)
          end
        end
      end
    end
  end
end
