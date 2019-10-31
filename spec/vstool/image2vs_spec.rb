require 'spec_helper'

module Vstool
	describe Image2vs do
		describe ".shorten_name" do
			before(:each) do
			end
			it "shorten name" do
				long_name = "dd_ol_dhofar_132_b11_bse@4758@4762"
				short_name = Image2vs.shorten_name(long_name)
				short_name.length.should <= 20
			end

			it "shorten name" do
				long_name = "ddoldhofar132b11bse@4758@4762"
				short_name = Image2vs.shorten_name(long_name)
				short_name.length.should <= 20
			end

			it "does not shorten name with short name" do
				long_name = "bse@4758@4762"
				short_name = Image2vs.shorten_name(long_name)
				short_name.should eql(long_name)
			end

		end

	end

	describe Image2vs do
		before(:each) do
			VisualStage::Base.clean
			VisualStage::Base.api = double('api')

			dir = "tmp"	
			deleteall(dir) if File.directory?(dir)
			Dir.mkdir(dir) unless File.directory?(dir)
		end


		describe "#new with '-h'" do
			let(:output) { double('output').as_null_object }
			let(:params) { {:output => output}}
			let(:argv) { ["-h"] }
			let(:app) { Image2vs.new(params) }
			it "show usage and exit" do
				STDERR.should_receive(:puts).with(/^usage:/)
				lambda {
					app.optionparse(argv)
				}.should raise_error(SystemExit)
			end
		end

		describe "#run with sem-supporter" do
			let(:output) { double('output').as_null_object }
			let(:opencvtool) { OpenCvTool::OpenCvTool.new }
			let(:params) { {:output => output, :opencvtool => opencvtool }}
			let(:argv) { ['tmp/sem-supporter.jpg'] }
			let(:app) { Image2vs.new(params, argv) }
			let(:affine){ [[1,0,0],[0,1,0],[0,0,1]] }
			before(:each) do
		  		argv.each do |dest|
			  		setup_file(dest)
			  		setup_file(filename_for(dest, :ext => :txt))
				end
				ImageInfo.stub(:from_sem_info).and_return(double('image_info').as_null_object)
		 		Vstool::Base.stub(:get_stage2world).and_return(affine)
		  		VisualStage::Base.stub(:current?).and_return(true)
		  		VisualStage::Base.stub(:init)
		  		VisualStage::Address.stub(:find_or_create_by_name).and_return(double('addr').as_null_object)
			end

			it "process files" do
		  		#argv.each do |filepath|
			  	#	app.should_receive(:process_file).with(filepath).and_return(true)
		  		#end	
		  		app.start
			end

	  	end

		describe "#start with dry_run option" do
		  let(:output) { double('output').as_null_object }
		  let(:opencvtool) { OpenCvTool::OpenCvTool.new }
		  let(:params) { {:dry_run => true, :output => output, :opencvtool => opencvtool }}
		  let(:argv) { ['tmp/chitech@002.tif'] }
		  let(:app) { Image2vs.new(params, argv) }
          let(:affine){ [[1,0,0],[0,1,0],[0,0,1]] }
		  before(:each) do

			argv.each do |dest|
				setup_file(dest)
				setup_file(filename_for(dest, :ext => :txt))
				#setup_file(filename_for(dest, :ext => :vs))
				#setup_file(filename_for(dest, :ext => :vs, :insert_path => '/deleteme.d/crop/'))
				#setup_file(filename_for(dest, :insert_path => '/deleteme.d/crop/'))					
				#setup_file(filename_for(dest, :ext => :vs, :insert_path => '/deleteme.d/@VS/'))
				#setup_file(filename_for(dest, :insert_path => '/deleteme.d/@VS/'))
			end
			ImageInfo.stub(:from_sem_info).and_return(double('image_info').as_null_object)
			Vstool::Base.stub(:get_stage2world).and_return(affine)
			VisualStage::Base.stub(:current?).and_return(true)
			VisualStage::Base.stub(:init)
			VisualStage::Address.stub(:find_or_create_by_name).and_return(double('addr').as_null_object)
		  end

		  it "process files" do
			argv.each do |filepath|
				app.should_receive(:process_file).with(filepath).and_return(true)
			end	
			app.start
		  end

		  it "load info-files" do
			argv.each do |filepath|
				info_file = filename_for(filepath, :ext => :txt)
				ImageInfo.should_receive(:from_sem_info).with(info_file, affine, {:image_path => filepath}).and_return(double('image_info').as_null_object)
			end	
			app.start
		  end

		  it "sends a prcessing message" do

			argv.each do |filepath|
				output.should_receive(:puts).with('processing |' + filepath + '|...')
			end
			app.start
		  end
		end

		describe "#start with exising vs", :current => true do

			let(:output) { double('output').as_null_object }
			let(:opencvtool) { OpenCvTool::OpenCvTool.new }
			let(:params) { {:output => output, :opencvtool => opencvtool }}
			let(:argv) { ['tmp/chitech@002.tif'] }
			let(:app) { Image2vs.new(params, argv) }

			before(:each) do

				argv.each do |dest|
					setup_file(dest)
					#setup_file(filename_for(dest, :ext => :txt))
					setup_file(filename_for(dest, :ext => :vs))
					setup_file(filename_for(dest, :ext => :vs, :insert_path => '/deleteme.d/@crop/'))
					setup_file(filename_for(dest, :insert_path => '/deleteme.d/@crop/'))					
					setup_file(filename_for(dest, :ext => :vs, :insert_path => '/deleteme.d/@crop@spin/'))
					setup_file(filename_for(dest, :insert_path => '/deleteme.d/@crop@spin/'))
				end
#				app.stub(:load_image_info).and_return(double('image_info'))
				ImageInfo.stub(:from_file).and_return(double('image_info').as_null_object)
				VisualStage::Base.stub(:current?).and_return(true)
				VisualStage::Base.stub(:init)
				VisualStage::Address.stub(:find_or_create_by_name).and_return(double('addr').as_null_object)
			end
			
			after(:each) do
				dir = "tmp"	
				deleteall(dir) if File.directory?(dir)
				Dir.mkdir(dir) unless File.directory?(dir)	
			end

			it "process files" do
				argv.each do |filepath|
					app.should_receive(:process_file).with(filepath).and_return(true)
				end	
				app.start
			end

			it "load geo-files" do
				argv.each do |filepath|
					geo_file = filename_for(filepath, :ext => :geo)
					ImageInfo.should_receive(:from_file).with(geo_file).and_return(double('image_info').as_null_object)
				end	
				app.start
			end

			it "sends a prcessing message" do

				argv.each do |filepath|
					output.should_receive(:puts).with('processing |' + filepath + '|...')
				end
				app.start
			end

		end

		describe "#start without exising vs" do

			let(:output) { double('output').as_null_object }
			let(:opencvtool) { OpenCvTool::OpenCvTool.new }
			let(:params) { {:output => output, :opencvtool => opencvtool }}
			let(:argv) { ['tmp/chitech@002.tif'] }
			let(:app) { Image2vs.new(params, argv) }
			let(:stage2vs){[[1,0,0],[0,1,0],[0,0,1]]}
			let(:image_info){ double('image_info').as_null_object }
			let(:crop_info){ double('crop_info').as_null_object }
			before(:each) do
				#Vstool.stub(:get_stage2world).and_return(stage2vs)
				argv.each do |dest|
					setup_file(dest)
					txt_file = filename_for(dest, :ext => :txt)
					setup_file(txt_file)
					image_info.stub(:crop).with(:path => filename_for(dest, :insert_path => 'deleteme.d/crop')).and_return(crop_info)
					#ImageInfo.stub(:from_sem_info).with(txt_file,stage2vs).and_return(double('image_info').as_null_object)
				end
				app.stub(:get_stage2world).and_return(stage2vs)
				VisualStage::Base.stub(:current?).and_return(true)
				VisualStage::Base.stub(:init)
				VisualStage::Address.stub(:find_or_create_by_name).and_return(double('addr').as_null_object)				
			end

			it "raise unless VisualStage::Base.current?" do
				VisualStage::Base.should_receive(:current?).and_return(false)
				argv.each do |filepath|
					output.should_receive(:puts).with('processing |' + filepath + '|...')
#					output.should_receive(:puts).with("...")
					STDERR.should_receive(:puts).with(/ERROR: VisualStage File is not opened/)
				end
				app.start
			end

			it "sends a prcessing message" do
				argv.each do |filepath|
					output.should_receive(:puts).with('processing |' + filepath + '|...')
					# output.should_receive(:puts).with(filename_for(filepath,:insert_path => '/deleteme.d/crop/') + ' exists...')										
					# output.should_receive(:puts).with(filename_for(filepath,:ext =>:vs,:insert_path => '/deleteme.d/crop/') + ' exists...')					
					# output.should_receive(:puts).with(filename_for(filepath,:insert_path => '/deleteme.d/@VS/') + ' exists...')										
					# output.should_receive(:puts).with(filename_for(filepath,:ext =>:vs,:insert_path => '/deleteme.d/@VS/') + ' exists...')										
				end
				app.start
			end
		end

	end
end