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

		describe "#process_file", :current => true do
			let(:output) { double('output').as_null_object }
			let(:params) { {:output => output }}
			let(:argv) { ['tmp/chitech@002.tif'] }
			let(:app) { Vsattach.new(params, argv) }

			let(:image_path) { 'tmp/chitech@002.tif' }		
			let(:vs_path) { 'tmp/chitech@002.vs' }
			before(:each) do
				setup_file(image_path)
				setup_file(vs_path)
			end		
			let(:image_info) { ImageInfo.from_file(vs_path) }
			let(:parms) { image_info.to_params }
			let(:addr) { double('addr') }
			it "raise error if no VS" do
				VisualStage::Base.should_receive(:current?).and_return(false)
				lambda {
					app.process_file(image_path)
				}.should raise_error(RuntimeError)
			end

			it "find_or_create_attach" do
				ImageInfo.should_receive(:load).and_return(image_info)
				VisualStage::Base.should_receive(:current?).and_return(true)
				basename = File.basename(image_path, ".*")
				#VisualStage::Address.should_receive(:refresh)
				VisualStage::Address.should_receive(:find_or_create_by_name).with(basename, image_info.to_params).and_return(addr)
				addr.should_receive(:find_or_create_attach_by_name).with('original', image_path, image_info.to_params.merge({:background => false}))				
				addr.should_receive(:find_or_create_attach_by_name).with('original-info', vs_path, image_info.to_params_for_info_file)				
				Vsattach.process_file(image_path, :addr_name => basename, :attach_name => 'original')
			end

			# it "attach image to vs" do
			# 	image_info.vs_attach
			# end		
		end

		end
end
