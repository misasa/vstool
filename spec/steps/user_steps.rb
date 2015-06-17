
def output
 	@output ||= double('output').as_null_object
end

#let(:output) { double('output').as_null_object }

step "I am not yet playing" do
 	@output = double('output').as_null_object
  	VisualStage::VS2007.stop if VisualStage::VS2007.is_running?
 	VisualStage::Base.clean	
end

step "I have a empty directory :dirname" do |dirname|
	deleteall(dirname) if File.directory?(dirname)
	FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
end

step "I have a file :filename" do |arg1|
	src_dir = File.expand_path('../../../spec/fixtures/data',__FILE__)
	filename = File.basename(arg1)
	dest_dir = File.dirname(arg1)
	src = File.join(src_dir, filename)
	FileUtils.copy(src, dest_dir)
end

step "I have started VisualStage" do
	VisualStage::Base.connect unless VisualStage::Base.connected?
end

step "I stop VisualStage" do
  	VisualStage::VS2007.stop if VisualStage::VS2007.is_running?	
end

step "I have a VisualStage data :dirname" do |dirname|
	setup_data(dirname)
end

step "I have started VisualStage with :dirname" do |dirname|
	VisualStage::VS2007.start
	VisualStage::Base.open(dirname)
	VisualStage::Base.clean
end

step "I have opened VisualStage with :dirname" do |dirname|
	VisualStage::Base.close("YES") if VisualStage::Base.current?

	setup_data(dirname)
	VisualStage::Base.open(dirname)
end


step "I start a new app" do
	app = Vstool::Image2vs.new({:output => output})
	app.start
end

step "I start a new app with :option" do |arg1|
# 	output = double('output').as_null_object	
	@argv = Shellwords.split(arg1)
	@app = Vstool::Image2vs.new({:output => @output, :stderr => @output},@argv)
	@app.start
end

step "I start a new app without file" do
# 	output = double('output').as_null_object	
	@app = Vstool::Image2vs.new({:output => @output, :stderr => @output})
end


step "I should see help message" do
	lambda {
		@app.start
	}.should raise_error(SystemExit)
end


step "I should see :message" do |message|
	output.messages.should include(message)
end

step "I should have a file :filename" do |arg1|
	File.exists?(arg1).should be_true
#  pending # express the regexp above with the code you wish you had
end
