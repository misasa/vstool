require 'spec_helper'

describe ImageInfo do
	before(:each) do
		dir = "tmp"	
		deleteall(dir) if File.directory?(dir)
		Dir.mkdir(dir)
	end


	describe ".load image with sem-info" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:txt_path) { 'tmp/chitech@002.txt' }
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { opencvtool.Haffine_from_params(:angle => 10) }

		#let(:loaded) { ImageInfo.load(image_path) }
		before(:each) do
			setup_file(image_path)
			setup_file(txt_path)
		end
		it "load sem-info with stage2world" do
			ImageInfo.should_receive(:from_sem_info).with(txt_path,stage2vs).and_return(ImageInfo.new)
			ImageInfo.load(image_path,:stage2world => stage2vs)
		end

		it "requires stage2world" do
			lambda {
				ImageInfo.load(image_path)
			}.should raise_error(RuntimeError)
		end


		it "returns instance of ImageInfo" do
			ImageInfo.load(image_path,:stage2world => stage2vs).should be_an_instance_of(ImageInfo)
		end

	end

	describe ".load image with info" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:vs_path) { 'tmp/chitech@002.vs' }
		#let(:loaded) { ImageInfo.load(image_path) }
		before(:each) do
			setup_file(image_path)
			setup_file(vs_path)
		end
		it "load sem-info" do
			ImageInfo.should_receive(:from_file).with(vs_path).and_return(ImageInfo.new)
			ImageInfo.load(image_path)
		end

		it "returns instance of ImageInfo" do
			ImageInfo.load(image_path).should be_an_instance_of(ImageInfo)
		end
	end

	describe "#crop image with info" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:vs_path) { 'tmp/chitech@002.vs' }
		let(:info) { ImageInfo.load(image_path) }
		before(:each) do
			setup_file(image_path)
			setup_file(vs_path)
		end
		it "creates crop-image" do
			crop_info = info.crop
			expect(File).to exist(crop_info.image_path)
		end

		it "creates crop-image with crop_percent" do
			crop_info = info.crop			
			crop10_info = info.crop(:crop_percent => 10)
			expect(File).to exist(crop_info.image_path)			
		end

		it "creates crop-image-info-file" do
			crop_info = info.crop
			crop_image_path = crop_info.image_path
			crop_vs_path = filename_for(crop_image_path, :ext => :vs)
			expect(File).to exist(crop_vs_path)
		end

		it "returns cropped-info" do
			info.crop.should be_an_instance_of(ImageInfo)
		end
	end


	describe "#warp image with info" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:vs_path) { 'tmp/chitech@002.vs' }
		let(:info) { ImageInfo.load(image_path) }
		let(:crop_info) { info.crop }
		before(:each) do
			setup_file(image_path)
			setup_file(vs_path)
		end
		it "creates warp-info" do
			warp_info = crop_info.warp
			warp_info.should be_an_instance_of(ImageInfo)
		end

		it "creates warp-image" do
			warp_info = crop_info.warp
			expect(File).to exist(warp_info.image_path)
		end

	end
	describe ".from_txt" do
		let(:txt_path) { 'tmp/chitech@002.txt' }
		before(:each) do
			setup_file(txt_path)
		end
		it "returns instance of ImageInfo" do
			ImageInfo.from_txt(txt_path).should be_an_instance_of(ImageInfo)
		end
	end

	describe ".textfile2array" do
		let(:txt_path) { 'tmp/chitech@002.txt' }
		before(:each) do
			setup_file(txt_path)
		end
		it "returns array" do
			ImageInfo.textfile2array(txt_path).should be_an_instance_of(Array)
		end
	end

	describe ".from_sem_info" do
		let(:txt_path) { 'tmp/chitech@002.txt' }
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { [[1,0,0],[0,1,0],[0,0,1]] }		
		let(:from_txt) { ImageInfo.from_txt(txt_path) }	
		let(:from_sem_info) { ImageInfo.from_sem_info(txt_path,stage2vs)}
		before(:each) do
			setup_file(txt_path)
		end
		it "returns instance of ImageInfo" do
			from_sem_info.should be_an_instance_of(ImageInfo)
		end

		it "returns same instance as ImageInfo.from_txt" do
			from_sem_info.locate.should eql(from_txt.locate)
		end
	end

	describe ".from_sem_info with affine" do
		let(:txt_path) { 'tmp/chitech@002.txt' }
		let(:vs_path) { 'tmp/chitech@002.vs'}		
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { opencvtool.Haffine_from_params(:angle => 10) }
		let(:from_txt) { ImageInfo.from_txt(txt_path) }	
		#let(:from_sem_info) { ImageInfo.from_sem_info(txt_path, stage2vs)}
		before(:each) do
			setup_file(txt_path)
			@from_sem_info = ImageInfo.from_sem_info(txt_path, stage2vs)		
		end
		it "returns instance of ImageInfo" do
			@from_sem_info.should be_an_instance_of(ImageInfo)
		end

		it "returns different instance as ImageInfo.from_txt" do
			@from_sem_info.locate.should_not eql(from_txt.locate)
		end

		it "dumps vs-file" do
			from_vs = ImageInfo.from_file(vs_path)
			@from_sem_info.locate.should eql(from_vs.locate)			
		end
	end

	describe "#.corners_on_world" do
		let(:txt_path) { 'tmp/chitech@002.txt'}
		let(:vs_path) { 'tmp/chitech@002.vs'}
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { opencvtool.Haffine_from_params(:angle => 10) }
		let(:from_txt) { ImageInfo.from_txt(txt_path) }	
		let(:from_sem_info) { ImageInfo.from_sem_info(txt_path, stage2vs)}
		before(:each) do
			setup_file(txt_path)
		end

		it "returns array of points" do
			from_sem_info.corners_on_world.should be_an_instance_of(Array)
		end


	end



end
