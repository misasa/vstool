require 'spec_helper'

module Vstool
    describe Import do
        describe "#new" do
            let(:output) { double('output').as_null_object }
            let(:params) { {:output => output}}
            let(:argv) { ["-h"] }
            let(:app) { Import.new(output, argv) }
            before do
                app
            end
            it "show usage and exit" do
                STDERR.should_receive(:puts).with(/^usage:/)
            end
        end

    end
end
