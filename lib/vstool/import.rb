module Vstool
    class Import < Base
        def initialize(output, argv = ARGV)
            @io = output
            @io.puts "initializing..."
            @argv = argv
			@option_parser = OptionParser.new do |opts|
				opts.banner = "usage: vs-import [options] VS-DIR SURFACE-NAME"
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			     	@verbose = v
			   	end
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					STDERR.puts opts.to_s
					exit
				end
			end            
            @params = @option_parser.parse(argv)
        end

        def cmd_options(argv = ARGV)
            
        end
    end
end
