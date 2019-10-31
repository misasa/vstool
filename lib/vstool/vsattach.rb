module Vstool
	class Vsattach < Base
		attr_accessor :params, :option, :verbose, :clear
		def initialize(params = {}, argv = nil)
			@params = params
			@output = params[:output] || STDOUT
			@stderr = params[:stderr] || STDERR
			@verbose = params[:verbose] || false
			@clear = params[:clear] || false
			@offline = params[:offline] || true
			@stage_origin = params[:stage_origin] || "ru"
			@world_origin = params[:world_origin] || "ld"

			@crop_percent = params[:crop_percent] || 10

			# @options = OptionParser.new do |opts|
			# 	script_name = File.basename($0)
			# 	opts.banner = "usage: #{script_name} [options] file"
			# 	opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			#     	params[:verbose] = v
			#   	end
			# 	# opts.on("-b", "--base-directory BASE_DIR", "Specify base directory: #{params[:base_path]}") do |v|
			# 	# 	params[:base_path] = v
			# 	# end   	
			# 	opts.on("-n", "--sample-name SAMPLE_NAME", "Specify sample name: #{params[:sample_name]}") do |v|
			# 		params[:sample_name] = v
			# 	end
			# 	opts.on("-p", "--point POINT_NUMBER", "Specify point number: #{params[:point_no]}") do |v|
			# 		params[:point_no] = v
			# 	end 
			# 	opts.on("-l", "--locate [X,Y]", "Specify locate in micro meter: ex. [0,0]") do |v|
			# 		locate = eval(v)
			# 		puts "invalid locate" unless locate.size == 2
			# 		params[:locate] = locate
			# 	end
			# 	opts.on("-s", "--size [X,Y]", "Specify size in micro meter: ex. [1280,640]") do |v|
			# 		size = eval(v)
			# 		puts "invalid size" unless size.size == 2
			# 		params[:size] = size
			# 	end
			# 	opts.on("-c", "--center [X,Y]", "Specify center in micro meter: ex. [640,320]") do |v|
			# 		val = eval(v)
			# 		puts "invalid center" unless val.size == 2
			# 		params[:center] = val
			# 	end
			# 	opts.on("-m", "--magnification MAGNIFICATION", "Specify magnification") do |v|
			# 		params[:magnification] = v
			# 	end
			# 	opts.on("-k", "--background", "Specify background image") do |v|
			#     	params[:background] = v
			#   	end
			# 	opts.on_tail("-h", "--help", "Show this message.") do |v|
			# 		puts opts
			# 		exit
			# 	end
			# end


			@option = OptionParser.new do |opts|
				#script_name = File.basename($0)
				opts.banner = "usage: image2vs [options] file ..."
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			    	@verbose = v
			  	end
				# opts.on("-c", "--[no-]clear", "Clear") do |v|
			 #    	@clear = v
			 #  	end			  	
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					@stderr.puts opts.to_s
					exit
				end
			end

			# raise "VS must be opened" unless VisualStage::Base.current?
			# VisualStage::Address.refresh
			# VisualStage::Base.init
			@inputfiles = []
			if argv
				@argv = argv
				@inputfiles = @option.parse(argv)

			end
		end

		def optionparse(argv)
			remains = @option.parse(argv)
			@inputfiles = remains
			remains
		end


		def start
			if @inputfiles.empty?
				@stderr.puts "specify imagefile"
				exit
			else
				@inputfiles.each do |file|
					process_file(file)
				end
			end
		end

		def self.process_file(filepath, opts = {})
			#return unless VisualStage::Base.current?
			if File.exist?(filepath_for(filepath,:ext => :geo))
				image_info = ImageInfo.load(filepath)
			elsif File.exist?(filepath_for(filepath,:ext => :vs))
				ImageInfo.vs2geo(filepath)
				image_info = ImageInfo.load(filepath)
			else
				image_info = ImageInfo.load(filepath, :stage2world => self.get_stage2world)
			end
			basename = File.basename(filepath, ".*")

			addr_name = opts[:addr_name] || basename
			attach_name = opts[:attach_name] || basename
			background = opts[:background] || false
			raise "ERROR: VisualStage File is not opened" unless VisualStage::Base.current?
#			VisualStage::Address.refresh
			adr = VisualStage::Address.find_or_create_by_name(addr_name, image_info.to_params)
			if adr
				adr.find_or_create_attach_by_name(attach_name,filepath, image_info.to_params.merge({:background => background}))
				adr.find_or_create_attach_by_name(attach_name + '-info',image_info.info_path, image_info.to_params_for_info_file)			
			end
		# rescue => ex
		# 	STDERR.puts ex.to_s	
		end

		def process_file(filepath)
			self.class.process_file(filepath)
		end
	end
end