module Vstool
	class Base

	 	def self.opencvtool
	    	@@opencvtool ||= OpenCvTool::OpenCvTool.new
	  	end

	  	def opencvtool
	    	self.class.opencvtool
	  	end		
	  	
		def self.option
			opt = OptionParser.new
			opt.on('-a'){|v| p v}
			return opt
		end

		def self.filepath_for(path, opts = {})
			extname = File.extname(path).sub(/\./,'')
			if opts[:ext]
				extname = opts[:ext].to_s
			end
			dirname = File.dirname(path)
			dirname = File.join(dirname,opts[:insert_path]) if opts[:insert_path]
			File.join(dirname, File.basename(path, ".*") + ".#{extname}")
		end

		def vs=(vs)
			@vs = vs
		end

		def vs
			@vs ||= VisualStage::Base.new({:verbose => @berbose})
		end

		def vs2007api
			@vs2007api ||= VisualStage::VS2007API.new({:verbose => @verbose})
		end

		# def opencvtool
		# 	@opencvtool ||= OpenCvTool.new(:verbose => @verbose)
		# end

		def get_stage2world
			self.class.get_stage2world
		end

		def self.get_stage2world
			raise "ERROR: VisualStage File is not opened" unless VisualStage::Base.current?
			width_world = 1000.0
			height_world = 1000.0
			points_on_world = [[-width_world,height_world],[width_world,height_world],[width_world,-height_world],[-width_world,-height_world]]
			points_on_stage = []
			points_on_world.each do |point_on_world|
#				points_on_stage << vs2007api.chg_world_to_stage(point_on_world[0], point_on_world[1]).map(&:to_f)
				points_on_stage << VisualStage::Base.world2stage(point_on_world)
			end

			from_points = points_on_stage
			to_points = points_on_world
			h = opencvtool.H_from_points(from_points, to_points)
			return h
		end

		def stage2vs=(stage2vs)
			@stage2vs = stage2vs
		end

		def stage2vs
			@stage2vs ||= get_stage2world
#			@stage2vs ||= get_affine(@vs2007api,@opencvtool) if @vs2007api && @opencvtool
		end

		def load_image_info(path)
			ImageInfo.from_file(path)
		end

		def load_image_info_from_txt(path)
			ImageInfo.from_sem_info(path)
		end

		def filepath_for(*args)
		 	self.class.filepath_for(*args)
		end

		def deleteall(delthem)
			if FileTest.directory?(delthem) then
				Dir.foreach( delthem ) do |file|
					next if /^\.+$/ =~ file
					deleteall(delthem.sub(/\/+$/,"") + "/" + file)
				end
				Dir.rmdir(delthem) rescue ""
			else
				File.delete(delthem)
			end
		end

		def setup_dir(dir)
		#	deleteall(dir) if File.directory?(dir)
		#	Dir.mkdir(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end

		def get_affine(vs2007api, opencvtool)
#			opencvtool = @opencvtool
			width_world = 1000.0
			height_world = 1000.0
			points_on_world = [[-width_world,height_world],[width_world,height_world],[width_world,-height_world],[-width_world,-height_world]]
			points_on_stage = []
			points_on_world.each do |point_on_world|
				points_on_stage << vs2007api.chg_world_to_stage(point_on_world[0], point_on_world[1]).map(&:to_f)
			end

			from_points = points_on_stage
			to_points = points_on_world
			h = opencvtool.H_from_points(from_points, to_points)
			return h
		end

		def setup_vs_image(corners_on_world, pixels_per_um, name = "vs_image")
			xs = corners_on_world.map{|x,y| x}.uniq
			x_range = xs.minmax
			ys = corners_on_world.map{|x,y| y}.uniq
			y_range = ys.minmax
			locate = [ (x_range[1] + x_range[0])/2, (y_range[1] + y_range[0])/2 ]
			size = [ x_range[1] - x_range[0], y_range[1] - y_range[0] ]
			center = [ size[0]/2, size[1]/2 ]
			pixs = size.map{|v| (v * pixels_per_um).ceil }
			vs_image_info = ImageInfo.new(:name => name, :locate => locate, :center => center, :size => size, :pixs => pixs)    		
			return vs_image_info
		end

		def crop_image(opencvtool, imagefile_path, image_info, cropped_image, crop_percent)
			crop_width = (image_info.pixs[0] * (100 - crop_percent)/100.0).round
			crop_height = (image_info.pixs[1] * (100 - crop_percent)/100.0).round
			crop_start_x = ((image_info.pixs[0] - crop_width)/2).round
			crop_start_y = ((image_info.pixs[1] - crop_height)/2).round
			opencvtool.crop_image(imagefile_path, :geometry => "#{crop_width}x#{crop_height}+#{crop_start_x}+#{crop_start_y}", :output_file => cropped_image)

			crop_width_in_um = crop_width.to_f/image_info.pixs[0] * image_info.size[0]
			crop_height_in_um = crop_height.to_f/image_info.pixs[1] * image_info.size[1]
			cropped_image_info = ImageInfo.new(:name => image_info.name, :locate => image_info.locate, :center => [crop_width_in_um/2, crop_height_in_um/2], :size => [crop_width_in_um, crop_height_in_um], :pixs => [crop_width, crop_height], :magnification => 120_000/crop_width_in_um, :stage_origin => image_info.stage_origin)
			return cropped_image_info
		end

		def vs_attach_image_file(vs2007api, image_path, opts = {})
			params = Hash.new
			if opts[:image_info_path]
				image_info_path = opts[:image_info_path]
				image_info = YAML.load_file(image_info_path)
				params[:name] = image_info["name"]
				params[:locate] = image_info["locate"]
				params[:size] = image_info["size"]
				params[:center] = image_info["center"]
			end

			params[:name] = opts[:name] if opts[:name]
			params[:background] = opts[:background] || false
			#vs2007api.create_address(params)
			vs2007api.attach_file(image_path, params)

			vs2007api.attach_file(image_info_path, :name => params[:name] + '-info') if opts[:image_info_path]
			vs2007api.file_save()		
		end

		def vs_create_address_and_attach_image_file(vs2007api, image_path, opts = {})
			params = Hash.new
			if opts[:image_info_path]
				image_info_path = opts[:image_info_path]
				image_info = YAML.load_file(image_info_path)
				params[:name] = image_info["name"]
				# params[:locate] = image_info["locate"]
				# params[:size] = image_info["size"]
				# params[:center] = image_info["center"]
			end

			params[:name] = opts[:name] if opts[:name]
			# params[:background] = opts[:background] || false
			vs2007api.create_address(params)
			vs_attach_image_file(vs2007api, image_path, opts)	
			# vs2007api.attach_file(image_path, params)
			# vs2007api.attach_file(image_info_path, :name => 'image-info')		
			# vs2007api.file_save()
		end
	end
end