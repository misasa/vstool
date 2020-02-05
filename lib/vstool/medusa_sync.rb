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
            checkout(surface_id, vs_dir)
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

        def import(vs_dir, surface_name, opts = {})
            puts "vs_dir: #{vs_dir}"
            puts "surface_name: #{surface_name}"
            #surface = MedusaRestClient::Surface.new(name: surface_name)    
            #surface.save
            #surface.reload
            abs_path = Pathname.getwd + Pathname.new(vs_dir)
            export_path = abs_path + "exported.txt"
            VisualStage::Base.open(abs_path)
            if VisualStage::Base.current?
                #txt = VisualStage::VS2007.addresslist
                #lines = txt.split("\n")
                #lines.each do |line|
                #    vals = line.split("\t")
                #    surface.create_spot(name: vals[2], world_x: vals[3], world_y: vals[4])
                #end
                txt = VisualStage::VS2007.attachlist
                lines = txt.split("\n")
                lines.each do |line|
                    puts line
                end
            end
        end

        def checkout(surface_id, vs_dir, opts = {})
            obj = MedusaRestClient::Record.find(surface_id)
            raise "#{surface_id} is not a surface record." unless obj.instance_of?(MedusaRestClient::Surface)
            abs_path = Pathname.getwd + Pathname.new(vs_dir)
            config_path = abs_path + "vstool.config"
            export_path = abs_path + "exported.txt"
            import_path = abs_path + "imported.txt"
            if VisualStage::Base.current?
                VisualStage::Base.create(abs_path)
                File.open(import_path, "w") do |txt|
                    txt.puts ["Class", "Name", "X-Locate", "Y-Locate", "Data"].join("\t")
                    obj.spots.each do |spot|
                        txt.puts ["0", spot.name, spot.world_x,  spot.world_y, spot.global_id].join("\t")
                    end
                end
                api = VisualStage::VS2007API.new()
                api.file_export(export_path)
                api.file_import(import_path)
                @output.puts "generating |#{config_path}|..."
                myconfigs = {surface_id: surface_id}
                open(File.expand_path(config_path), "w") do |f|
                    YAML.dump(myconfigs, f)
                end
            end
        end

    end
end
