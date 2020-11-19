module Vstool
	class Image2vs < Base
		attr_accessor :params, :option, :verbose, :clear
		def self.shorten_name(name)
			return name if name.size <= 20
			words = name.split('_')
			tmp = "shortname"
			if words.size > 0
				last_word = words.pop
				return last_word[(last_word.size-20)..-1] if last_word.size > 20
				name = last_word
				while true
					word = words.pop
					break unless word
					tmp = word + "_" + name
#					p "#{tmp} [#{tmp.size}]"
					break if tmp.size > 20
					name = tmp
				end
				return name
			end


			return last_word
		end

		def shorten_name(name)
			self.class.shorten_name(name)
		end

		def initialize(params = {}, argv = nil)
			params = {:attach_crop => true, :logger => Logger.new(STDERR)}.merge(params)
			@params = params
			@output = params[:output] || STDOUT
			@stderr = params[:stderr] || STDERR
			@verbose = params[:verbose] || false
			@clear = params[:clear] || false
			@offline = params[:offline] || true
			@dry_run = params[:dry_run]
			@attach_crop = params[:attach_crop]
			@logger = params[:logger]
			@stage_origin = params[:stage_origin] || "ru"
			@world_origin = params[:world_origin] || "ld"

			@opencvtool = OpenCvTool::OpenCvTool.new(:verbose => @verbose)
			#@opencvtool = params[:opencvtool]
			@vs2007api = params[:vs2007api]

			@crop_percent = params[:crop_percent] || 10

			@option = OptionParser.new do |opts|
				opts.banner = "usage: image2vs [options] file ..."
				opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
			     	@verbose = v
			   	end
				# opts.on("-c", "--[no-]clear", "Clear") do |v|
			 #    	@clear = v
			 #  	end
			 	opts.on_tail("-h", "--help", "Show this message.") do |v|
					STDERR.puts opts.to_s
					exit
				end
			end
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

		def inputfiles
			@inputfiles
		end

		def inputfiles=(files)
			@inputfiles = files
		end

		def start
			if @inputfiles.empty?
				@stderr.puts "specify imagefile"
				exit
			else
				process_files
			end
		end

		def process_file(imagefile)
			original_image = imagefile
			imagefile_path = imagefile

			dirname = File.dirname(imagefile_path)
			basename = File.basename(imagefile_path,".*")
			extname = File.extname(imagefile_path)
			image_txt_path = filepath_for(imagefile_path, :ext => :txt)
			image_info_file = filepath_for(imagefile_path, :ext => :geo)

			tmp_dir = "deleteme.d"
			cropped_dir = File.join(tmp_dir, "@crop")
			cropped_image = filepath_for(imagefile, :insert_path => cropped_dir)
			cropped_image_info_file = filepath_for(imagefile, :ext => :geo, :insert_path => cropped_dir)

			vs_dir = File.join(tmp_dir, "@crop@spin")
			vs_image = filepath_for(imagefile, :insert_path => vs_dir)
			vs_image_info_file = filepath_for(imagefile, :ext => :geo, :insert_path => vs_dir)

			raise "#{imagefile_path} does not exist" unless File.exists?(imagefile_path)

			@logger.info "processing |#{imagefile_path}|..."
			setup_dir(File.join(dirname,tmp_dir))
			setup_dir(File.join(dirname,cropped_dir))
			setup_dir(File.join(dirname,vs_dir))

			unless File.exists?(image_info_file)
				ImageInfo.vs2geo(imagefile_path) if File.exists?(filepath_for(imagefile_path, :ext => :vs))
			end

			unless File.exists?(cropped_image_info_file)
				ImageInfo.vs2geo(cropped_image) if File.exists?(filepath_for(imagefile, :ext => :vs, :insert_path => cropped_dir))
			end

			unless File.exists?(vs_image_info_file)
				ImageInfo.vs2geo(vs_image) if File.exists?(filepath_for(imagefile, :ext => :vs, :insert_path => vs_dir))
			end

			unless File.exists?(image_info_file)
			 	raise "#{image_txt_path} does not exist" unless File.exists?(image_txt_path)
			 	raise "ERROR: VisualStage File is not opened or vs command is not available. try 'vs status'." unless VisualStage::Base.current?
				ImageInfo.from_sem_info(image_txt_path, get_stage2world, :image_path => imagefile)
			end
			return imagefile if @dry_run
			
			unless File.exists?(cropped_image) && File.exists?(cropped_image_info_file)
			# 	@output.puts "#{cropped_image} exists..."
			# 	@output.puts "#{cropped_image_info_file} exists..."
			# 	cropped_image_info = ImageInfo.from_file(cropped_image_info_file)
			# else
				@logger.info "generating |#{cropped_image}|..."
				raise "#{image_info_file} does not exsit" unless File.exists?(image_info_file)
				image_info = ImageInfo.load(imagefile)
				cropped_image_info = image_info.crop(:path => cropped_image)
			end

			unless File.exists?(vs_image) && File.exists?(vs_image_info_file)
			# 	@output.puts "#{vs_image} exists..."
			# 	@output.puts "#{vs_image_info_file} exists..."
			# 	vs_image_info = ImageInfo.from_file(vs_image_info_file)
			# else
				@logger.info "generating |#{vs_image}|..."
				raise "#{cropped_image_info_file} does not exist" unless File.exists?(cropped_image_info_file)
				crop_info = ImageInfo.load(cropped_image)
				vs_image_info = crop_info.warp(:path => vs_image)
			end

			if VisualStage::Base.current?
				begin
					config_path = File.join(File.join(dirname,tmp_dir),'image2vs.config')
					#@output.puts "loading |#{File.expand_path(config_path)}|..."
				  	myconfigs      = YAML.load(File.read(File.expand_path(config_path)))
				  	vsdata_path = myconfigs['vsdata_path']
				rescue
				  @logger.info "generating |#{File.expand_path(config_path)}|..."
				  myconfigs		= {}
				end
				unless VisualStage::Base.data_dir
					if myconfigs[:vsdata_path] && File.exists?(myconfigs[:vsdata_path])
						VisualStage::Base.data_dir = myconfigs[:vsdata_path]
						VisualStage::Base.refresh
					else
						VisualStage::Base.init
						myconfigs[:vsdata_path] = VisualStage::Base.data_dir
						open(File.expand_path(config_path), "w") do |f|
							YAML.dump(myconfigs, f)
						end
					end
				end
				VisualStage::Base.refresh if VisualStage::Base.data_dir
#				VisualStage::Address.refresh
				basename = File.basename(original_image,".*")
				addr_name = shorten_name(basename)
				Vsattach.process_file(original_image, :addr_name => addr_name, :attach_name => shorten_name(basename))
				Vsattach.process_file(cropped_image, :addr_name => addr_name, :attach_name => shorten_name(basename + '@crop')) if @attach_crop
				Vsattach.process_file(vs_image, :addr_name => addr_name, :attach_name => shorten_name(basename + '@crop@spin'), :background => true)
			end
			return imagefile
		rescue => ex
			@stderr.puts ex.to_s
		end

		def read_or_create_config_file
			config_path
		end

		def process_files
			raise "specify imagefile" if @inputfiles.size == 0

			processed = []
			@inputfiles.each do |imagefile|
#			while imagefile = @inputfiles.shift
				processed << process_file(imagefile)
			end
			if VisualStage::Base.current?
				VisualStage::Base.file_save
			end
			return processed.compact
		end
	end
end
