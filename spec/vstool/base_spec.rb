require 'spec_helper'

module Vstool
	describe Base do
		describe ".filepath_for" do
			let(:original_path) { "hello.tif"}
			it "returns vs-file path with :ext => :vs" do
				path = Base.filepath_for(original_path, :ext => :vs)
				File.extname(path).should eql(".vs")
			end
		end

		describe ".filepath_for" do
			let(:original_path) { "hello.tif"}
			it "returns vs-file path with :ext => :vs, :insert_path => 'deleteme.d/crop/'" do
				path = Base.filepath_for(original_path, :ext => :vs, :insert_path => '/deleteme.d/crop/')
				File.dirname(path).should eql('./deleteme.d/crop')
			end
		end

		describe "#filepath_for" do
			let(:original_path) { "hello.tif"}
			let(:obj) { Base.new }
			it "returns vs-file path with :ext => :vs" do
				path = obj.filepath_for(original_path, :ext => :vs)
			end
		end

		describe "#stage2vs" do
			let(:obj) { Base.new }
			it "returns @stage2vs if @stage2vs not nil" do
				array = [[1,0,0], [0,1,0],[0,0,1]]
				obj.stage2vs = array
				obj.stage2vs.should eql(array)
			end

			it "raise error if VisualStage File is not opened" do
				VisualStage::Base.should_receive(:current?).and_return(false)
				expect {
					obj.stage2vs
				}.to raise_error(RuntimeError, /ERROR: VisualStage File is not opened/)				
			end

			it "call VisualStage::Base.world2stage" do
				VisualStage::Base.should_receive(:current?).and_return(true)
				VisualStage::Base.should_receive(:world2stage).with([-1000.0,1000.0]).and_return([-1000.0,1000.0])				
				VisualStage::Base.should_receive(:world2stage).with([1000.0,1000.0]).and_return([1000.0,1000.0])
				VisualStage::Base.should_receive(:world2stage).with([-1000.0,-1000.0]).and_return([-1000.0,-1000.0])
				VisualStage::Base.should_receive(:world2stage).with([1000.0,-1000.0]).and_return([1000.0,-1000.0])
				#VisualStage::VS2007API.should_receive(:new).and_return(vs2007api)
				#obj.should_receive(:vs2007api).and_return(vs2007api)
				obj.stage2vs
			end
		end


	end
end