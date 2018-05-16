module GeoCli
  module Commands
    class Base
      attr_reader :global_opts, :opts, :args, :instream
      def initialize(instream, global_opts = {}, opts = {}, args = [])
        @global_opts = global_opts
        @opts = opts
        @args = args
        @instream = instream
      end

      def output
        raise "Not implemented"
      end
    end
  end
end
