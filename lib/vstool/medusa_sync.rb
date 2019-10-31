module Vstool
    class MedusaSync < Base
        def initialize(params = {})
			@params = params
			@output = params[:output] || STDOUT
			@stderr = params[:stderr] || STDERR
			@verbose = params[:verbose] || false
        end

        def verbose
            @params[:verbose]
        end

        def run_import(argv = ARGV)
			option_parser = OptionParser.new do |opts|
				opts.banner = "usage: vs-import [options] VS-DIR SURFACE-NAME"
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			     	@params[:verbose] = v
			   	end
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					@stderr.puts opts.to_s
					exit
				end
			end                        
            argv = option_parser.parse(argv)
            @output.puts "argv: #{argv}" if verbose
            @output.puts "options: #{@params}" if verbose
            unless argv.size == 2
                @stderr.puts "invalid arguments"
                @stderr.puts option_parser.banner
                exit
            end
            vs_dir = argv.shift
            surface_name = argv.shift
            @output.puts "VS-DIR: #{vs_dir}" if verbose
            @output.puts "SURFACE-NAME #{surface_name}" if verbose
            @stderr.puts "not implemented"
        end

        def run_checkout(argv = ARGV)
			option_parser = OptionParser.new do |opts|
				opts.banner = "usage: vs-checkout [options] SURFACE-ID VS-DIR"
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			     	@params[:verbose] = v
			   	end
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					@stderr.puts opts.to_s
					exit
				end
			end                        
            argv = option_parser.parse(argv)
            @output.puts "argv: #{argv}" if verbose
            @output.puts "options: #{@params}" if verbose
            unless argv.size == 2
                @stderr.puts "invalid arguments"
                @stderr.puts option_parser.banner
                exit
            end
            surface_id = argv.shift
            vs_dir = argv.shift
            @output.puts "SURFACE-ID: #{surface_id}" if verbose
            @output.puts "VS-DIR #{vs_dir}" if verbose
            @stderr.puts "not implemented"
        end

        def run_update(argv = ARGV)
			option_parser = OptionParser.new do |opts|
				opts.banner = "usage: vs-update [options] VS-DIR"
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			     	@params[:verbose] = v
			   	end
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					@stderr.puts opts.to_s
					exit
				end
			end                        
            argv = option_parser.parse(argv)
            @output.puts "argv: #{argv}" if verbose
            @output.puts "options: #{@params}" if verbose
            unless argv.size == 1
                @stderr.puts "invalid arguments"
                @stderr.puts option_parser.banner
                exit
            end
            vs_dir = argv.shift
            @output.puts "VS-DIR #{vs_dir}" if verbose
            @stderr.puts "not implemented"
        end

        def run_commit(argv = ARGV)
			option_parser = OptionParser.new do |opts|
				opts.banner = "usage: vs-commit [options] VS-DIR"
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			     	@params[:verbose] = v
			   	end
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					@stderr.puts opts.to_s
					exit
				end
			end                        
            argv = option_parser.parse(argv)
            @output.puts "argv: #{argv}" if verbose
            @output.puts "options: #{@params}" if verbose
            unless argv.size == 1
                @stderr.puts "invalid arguments"
                @stderr.puts option_parser.banner
                exit
            end
            vs_dir = argv.shift
            @output.puts "VS-DIR #{vs_dir}" if verbose
            @stderr.puts "not implemented"
        end

    end
end
