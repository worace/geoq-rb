module Geoq
  module Commands
    module GeoHash
      class Point < Base
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

      class Children < Base
        def output
          Enumerator.new do |e|
            instream.each do |entity|
              entity.gh_children.each do |gh|
                e << gh
              end
            end
          end
        end
      end

      class Neighbors < Base
        def output
          Enumerator.new do |e|
            instream.each do |entity|
              entity.gh_neighbors(opts[:inclusive]).each do |gh|
                e << gh
              end
            end
          end
        end
      end
    end
  end
end
