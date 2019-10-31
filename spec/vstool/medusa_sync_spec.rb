require 'spec_helper'

module Vstool
    describe MedusaSync do
        describe "#new", :current => true do
            subject { MedusaSync.new(params) }
            let(:output) { double('output').as_null_object }
            let(:params) { {:output => output}}
            let(:app) { MedusaSync.new(params) }
            it "with output" do
                expect{ subject }.not_to raise_error
            end
        end

        describe "run_import", :current => true do
            subject { app.run_import(argv) }
            let(:output) { double('output') }
            let(:params) { {:stderr => output}}
            let(:app) { MedusaSync.new(params) }
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
