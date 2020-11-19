require 'spec_helper'

describe ImageInfo do
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
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
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

	describe ".vs2geo" do
		subject { ImageInfo.vs2geo(image_path) }
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:vs_path) { 'tmp/chitech@002.vs' }
		let(:geo_path) { 'tmp/chitech@002.geo' }
		before(:each) do
			setup_file(image_path)
			setup_file(vs_path)
		end
		it "generates geo" do
			subject
			expect(File).to exist(geo_path)
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end
	end

	describe ".load image with geo-file" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:geo_path) { 'tmp/chitech@002.geo' }
		before(:each) do
			setup_file(image_path)
			setup_file(geo_path)
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end
		it "load geo_file" do
			ImageInfo.should_receive(:from_file).with(geo_path).and_return(ImageInfo.new)
			ImageInfo.load(image_path)
		end
	end


	describe ".load image with vs-file" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:vs_path) { 'tmp/chitech@002.vs' }
		let(:geo_path) { 'tmp/chitech@002.geo' }
		#let(:loaded) { ImageInfo.load(image_path) }
		before(:each) do
			setup_file(image_path)
			setup_file(vs_path)
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end
		it "load geo_file" do
			ImageInfo.should_receive(:from_file).with(geo_path).and_return(ImageInfo.new)
			ImageInfo.load(image_path)
		end

		it "returns instance of ImageInfo" do
			ImageInfo.load(image_path).should be_an_instance_of(ImageInfo)
		end
	end

	describe "#crop image with info" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:geo_path) { 'tmp/chitech@002.geo' }
		let(:info) { ImageInfo.load(image_path) }
		before(:each) do
			setup_file(image_path)
			setup_file(geo_path)
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
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
			crop_geo_path = filename_for(crop_image_path, :ext => :geo)
			expect(File).to exist(crop_geo_path)
		end

		it "returns cropped-info" do
			info.crop.should be_an_instance_of(ImageInfo)
		end
	end


	describe "#warp image with info" do
		let(:image_path) { 'tmp/chitech@002.tif' }		
		let(:geo_path) { 'tmp/chitech@002.geo' }
		let(:info) { ImageInfo.load(image_path) }
		let(:crop_info) { info.crop }
		before(:each) do
			setup_file(image_path)
			setup_file(geo_path)
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end

		it "creates warp-info" do
			warp_info = crop_info.warp
			warp_info.should be_an_instance_of(ImageInfo)
		end

		it "creates warp-image-info-file" do
			warp_info = crop_info.warp
			warp_geo_path = filename_for(warp_info.image_path, :ext => :geo)
			expect(File).to exist(warp_geo_path)
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
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { [[1,0,0],[0,1,0],[0,0,1]] }		
		let(:from_txt) { ImageInfo.from_txt(txt_path) }	
		let(:from_sem_info) { ImageInfo.from_sem_info(txt_path,stage2vs,opts)}
		let(:opts){ {} }
		before(:each) do
			setup_file(txt_path)
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end
		context "with chitech" do
		  let(:txt_path) { 'tmp/chitech@002.txt' }

		  it "returns instance of ImageInfo" do
		    from_sem_info.should be_an_instance_of(ImageInfo)
		  end

		  it "generates geo-file" do
			info = from_sem_info
			geo_path = filename_for(txt_path, :ext => :geo)
			expect(File).to exist(geo_path)
		  end

		  it "returns same instance as ImageInfo.from_txt" do
		    from_sem_info.locate.should eql(from_txt.locate)
		  end
		end

		context "with SEM supporter" do
		  let(:txt_path) { 'tmp/sem-supporter.txt' }
		  let(:image_path) { 'tmp/sem-supporter.jpg' }
		  let(:opts){ {:image_path => image_path} }
		  before do
			setup_file(image_path)
		  end

		  it "returns instance of ImageInfo" do
		    from_sem_info.should be_an_instance_of(ImageInfo)
		  end
  		end  
		context "with chd-K4-c" do
			let(:txt_path) { 'tmp/chd-K4-c.txt' }
			let(:image_path) { 'tmp/chd-K4-c.png' }
			let(:opts){ {:image_path => image_path} }
			before do
			  setup_file(image_path)
			end

			it "returns instance of ImageInfo" do
			  from_sem_info.should be_an_instance_of(ImageInfo)
			end
		end    
		context "with X001_Y009", :current => true do
			let(:txt_path) { 'tmp/X001_Y009.txt' }
			let(:stage2vs) { [[1.0,0.0,0.0],[0.0,1.0,0.0],[0.0,0.0,1]] }
			let(:image_path) { 'tmp/X001_Y009.png' }
			let(:opts){ {:image_path => image_path} }
			before do
			  setup_file(image_path)
			end

			it "returns instance of ImageInfo" do
			  from_sem_info.should be_an_instance_of(ImageInfo)
			end
		end    
		context "with X001_Y010", :current => true do
			let(:txt_path) { 'tmp/X001_Y010.txt' }
			let(:stage2vs) { [[1.0,0.0,0.0],[0.0,1.0,0.0],[0.0,0.0,1]] }
			let(:image_path) { 'tmp/X001_Y010.png' }
			let(:opts){ {:image_path => image_path} }
			before do
			  setup_file(image_path)
			end

			it "returns instance of ImageInfo" do
			  from_sem_info.should be_an_instance_of(ImageInfo)
			end
		end    

	end

	describe ".rotate_xy" do
		let(:xy){ [1,0] }
		let(:angle){ 45 }
		before { ImageInfo.rotate_xy(xy, angle) }
		it { expect(ImageInfo.rotate_xy(xy, angle)).to be_an_instance_of(Array)}
		context "with center" do
			let(:center){ [100,200] }
			before { ImageInfo.rotate_xy(xy, angle, center) }
			it { expect(ImageInfo.rotate_xy(xy, angle, center)).to be_an_instance_of(Array)}
		end
	end

	describe ".from_sem_info with affine" do
		let(:txt_path) { 'tmp/chitech@002.txt' }
		let(:geo_path) { 'tmp/chitech@002.geo'}		
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { opencvtool.Haffine_from_params(:angle => 10) }
		let(:from_txt) { ImageInfo.from_txt(txt_path) }	
		#let(:from_sem_info) { ImageInfo.from_sem_info(txt_path, stage2vs)}
		before(:each) do
			setup_file(txt_path)
			@from_sem_info = ImageInfo.from_sem_info(txt_path, stage2vs)		
		end
		after(:each) do
			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end
		it "returns instance of ImageInfo" do
			@from_sem_info.should be_an_instance_of(ImageInfo)
		end

		it "returns different instance as ImageInfo.from_txt" do
			@from_sem_info.locate.should_not eql(from_txt.locate)
		end

		it "dumps geo-file" do
			from_geo = ImageInfo.from_file(geo_path)
			@from_sem_info.locate.should eql(from_geo.locate)			
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

	describe "#.corners_on_xy" do
		let(:image_path) { 'tmp/chitech@002.tif'}
		let(:txt_path) { 'tmp/chitech@002.txt'}
		#let(:vs_path) { 'tmp/chitech@002.vs'}
		#let(:dimension){ ImageInfo.image_dimension(image_path)}
		let(:dimension){ [1280, 1024] }
	 	let(:opencvtool) { OpenCvTool::OpenCvTool.new }		
	 	let(:stage2vs) { opencvtool.Haffine_from_params(:angle => 10) }
		let(:from_txt) { ImageInfo.from_txt(txt_path) }	
		before(:each) do
			setup_file(txt_path)
			setup_file(image_path)
		end

		context "without image_path" do
			let(:from_sem_info) { ImageInfo.from_sem_info(txt_path, stage2vs)}
			it "returns array of points" do
				corners_on_xy = from_sem_info.corners_on_xy
				corners_on_xy[0].should be_eql([-50.0,37.5])
				corners_on_xy[1].should be_eql([50.0,37.5])
				corners_on_xy[2].should be_eql([50.0,-37.5])
				corners_on_xy[3].should be_eql([-50.0,-37.5])
			end
		end


		context "with image_path" do
			let(:from_sem_info) { ImageInfo.from_sem_info(txt_path, stage2vs, :image_path => image_path)}
			it "returns array of points" do
				corners_on_xy = from_sem_info.corners_on_xy
				corners_on_xy[0].should be_eql([-50.0,40.0])
				corners_on_xy[1].should be_eql([50.0,40.0])
				corners_on_xy[2].should be_eql([50.0,-35.0])
				corners_on_xy[3].should be_eql([-50.0,-35.0])
			end
		end
	end



end
