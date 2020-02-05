require 'spec_helper'

module Vstool
	describe Vsattach do
		before(:each) do
			VisualStage::Base.clean
			VisualStage::Base.api = double('api')
		end

		describe ".new" do
			it "creates a instance" do
			end
		end

		describe "#process_file" do
			let(:output) { double('output').as_null_object }
			let(:params) { {:output => output }}
			let(:argv) { ['tmp/chitech@002.tif'] }
			let(:app) { Vsattach.new(params, argv) }

			let(:image_path) { 'tmp/chitech@002.tif' }		
			let(:vs_path) { 'tmp/chitech@002.vs' }
			let(:geo_path) { 'tmp/chitech@002.geo' }
			#let(:image_info) { ImageInfo.from_file(vs_path) }
			let(:parms) { image_info.to_params }
			let(:addr) { double('addr') }
			it "raise error if no VS" do
				VisualStage::Base.should_receive(:current?).and_return(false)
				lambda {
					app.process_file(image_path)
				}.should raise_error(RuntimeError)
			end

			context "without geo-file", :current => true do
				before(:each) do
					dir = "tmp"	
					deleteall(dir) if File.directory?(dir)
					Dir.mkdir(dir) unless File.directory?(dir)
					setup_file(image_path)
				end
				after(:each) do
					dir = "tmp"	
					deleteall(dir) if File.directory?(dir)
					Dir.mkdir(dir) unless File.directory?(dir)
				end
		
				let(:image_info) { double('image_info').as_null_object }			
				let(:addr) { double('addr').as_null_object }
				let(:affine){ double('affine').as_null_object } 
				it "require get_stage2world" do
					allow(Vstool::Base).to receive(:get_stage2world).with(any_args).and_return(affine)
					allow(ImageInfo).to receive(:load).with(image_path, :stage2world => affine).and_return(image_info)
					VisualStage::Base.should_receive(:current?).and_return(true)
					basename = File.basename(image_path, ".*")
					allow(VisualStage::Address).to receive(:find_or_create_by_name).and_return(addr)
					Vsattach.process_file(image_path, :addr_name => basename, :attach_name => 'original')
				end
			end

			context "with geo-file" do
				before(:each) do
					setup_file(image_path)
					setup_file(geo_path)
				end
				after(:each) do
					dir = "tmp"	
					deleteall(dir) if File.directory?(dir)
					Dir.mkdir(dir) unless File.directory?(dir)
				end
		
				let(:image_info) { double('image_info').as_null_object }			
				let(:addr) { double('addr').as_null_object }
				let(:affine){ double('affine').as_null_object } 
				it "load geo_file" do
					#allow(Vstool::Base).to receive(:get_stage2world).with(any_args).and_return(affine)
					allow(ImageInfo).to receive(:load).with(image_path).and_return(image_info)
					VisualStage::Base.should_receive(:current?).and_return(true)
					basename = File.basename(image_path, ".*")
					allow(VisualStage::Address).to receive(:find_or_create_by_name).and_return(addr)
					Vsattach.process_file(image_path, :addr_name => basename, :attach_name => 'original')
				end
			end

			context "with vs-file" do
				before(:each) do
					setup_file(image_path)
					setup_file(vs_path)
				end
				after(:each) do
					dir = "tmp"	
					deleteall(dir) if File.directory?(dir)
					Dir.mkdir(dir) unless File.directory?(dir)
				end
		
				let(:image_info) { double('image_info').as_null_object }			
				let(:addr) { double('addr').as_null_object }
				let(:affine){ double('affine').as_null_object } 
				it "load geo_file" do
					#allow(Vstool::Base).to receive(:get_stage2world).with(any_args).and_return(affine)
					allow(ImageInfo).to receive(:load).with(image_path).and_return(image_info)
					VisualStage::Base.should_receive(:current?).and_return(true)
					basename = File.basename(image_path, ".*")
					allow(VisualStage::Address).to receive(:find_or_create_by_name).and_return(addr)
					Vsattach.process_file(image_path, :addr_name => basename, :attach_name => 'original')
				end
			end

			context "with vs-file", :current => true do
				before(:each) do
					setup_file(image_path)
					setup_file(vs_path)
				end			
				after(:each) do
					dir = "tmp"	
					deleteall(dir) if File.directory?(dir)
					Dir.mkdir(dir) unless File.directory?(dir)
				end

				let(:image_info) { ImageInfo.from_file(vs_path) }

				it "find_or_create_attach" do
#					allow(ImageInfo).to receive(:load).with(image_path).and_return(image_info)
					ImageInfo.should_receive(:load).and_return(image_info)
					VisualStage::Base.should_receive(:current?).and_return(true)
					basename = File.basename(image_path, ".*")
					VisualStage::Address.should_receive(:find_or_create_by_name).with(basename, image_info.to_params).and_return(addr)
					addr.should_receive(:find_or_create_attach_by_name).with('original', image_path, image_info.to_params.merge({:background => false}))				
					addr.should_receive(:find_or_create_attach_by_name).with('original-info', vs_path, image_info.to_params_for_info_file)				
					Vsattach.process_file(image_path, :addr_name => basename, :attach_name => 'original')
				end
			end
			# it "attach image to vs" do
			# 	image_info.vs_attach
			# end		
		end

		end
end
