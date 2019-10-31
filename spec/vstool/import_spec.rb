require 'spec_helper'

module Vstool
    describe Import do
        describe "#new", :current => true do
            subject { Import.new(params) }
            let(:output) { double('output').as_null_object }
            let(:params) { {:output => output}}
            let(:argv) { ["-h"] }
            let(:app) { Import.new(params) }
            it "with output" do
                expect{ subject }.not_to raise_error
            end
        end

        describe "run", :current => true do
            subject { app.run(argv) }
            let(:output) { double('output') }
            let(:params) { {:stderr => output}}
            let(:app) { Import.new(params) }
            context "with valid args" do
                let(:argv) {["VS-DIR", "SURFACE-NAME"]}
                it "show message" do
                    allow(output).to receive(:puts).with("not implemented")
                    subject
                end
            end
            context "without args" do
                let(:argv) {[]}
                it "raise error" do
                    #allow(output).to receive(:puts).with("not implemented")
                    expect{ subject }.to raise_error
                end
            end
        end

    end
end
