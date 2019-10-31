require 'spec_helper'

module Vstool
    describe MedusaSync do
        describe "#new", :current => false do
            subject { MedusaSync.new(params) }
            let(:output) { double('output').as_null_object }
            let(:params) { {:output => output}}
            let(:app) { MedusaSync.new(params) }
            it "with output" do
                expect{ subject }.not_to raise_error
            end
        end

        describe "run_import", :current => false do
            subject { app.run_import(argv) }
            let(:output) { double('output') }
            let(:params) { {:stderr => output}}
            let(:app) { MedusaSync.new(params) }
            context "with -h" do
                let(:argv) {["-h"]}
                let(:params){ {} }
                it "show banner" do
                    expect{ subject }.to raise_error SystemExit
                end
            end
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

        describe "run_checkout", :current => true do
            subject { app.run_checkout(argv) }
            let(:output) { double('output') }
            let(:params) { {:stderr => output}}
            let(:app) { MedusaSync.new(params) }
            context "with -h" do
                let(:argv) {["-h"]}
                let(:params){ {} }
                it "show banner" do
                    expect{ subject }.to raise_error SystemExit
                end
            end
            context "with valid args" do
                let(:argv) {["-v", "surface_id", "vs_dir"]}
                it "show message" do
                    allow(output).to receive(:puts).with("not implemented")
                    subject
                end
            end
            context "without args" do
                let(:argv) {[]}
                it "raise error" do
                    expect{ subject }.to raise_error
                end
            end
        end        

        describe "run_update", :current => true do
            subject { app.run_update(argv) }
            let(:output) { double('output') }
            let(:params) { {:stderr => output}}
            let(:app) { MedusaSync.new(params) }
            context "with -h" do
                let(:argv) {["-h"]}
                let(:params){ {} }
                it "show banner" do
                    expect{ subject }.to raise_error SystemExit
                end
            end
            context "with valid args" do
                let(:argv) {["-v", "vs_dir"]}
                it "show message" do
                    allow(output).to receive(:puts).with("not implemented")
                    subject
                end
            end
            context "without args" do
                let(:argv) {[]}
                it "raise error" do
                    expect{ subject }.to raise_error
                end
            end
        end                

        describe "run_commit", :current => true do
            subject { app.run_commit(argv) }
            let(:output) { double('output') }
            let(:params) { {:stderr => output}}
            let(:app) { MedusaSync.new(params) }
            context "with -h" do
                let(:argv) {["-h"]}
                let(:params){ {} }
                it "show banner" do
                    expect{ subject }.to raise_error SystemExit
                end
            end
            context "with valid args" do
                let(:argv) {["-v", "vs_dir"]}
                it "show message" do
                    allow(output).to receive(:puts).with("not implemented")
                    subject
                end
            end
            context "without args" do
                let(:argv) {[]}
                it "raise error" do
                    expect{ subject }.to raise_error
                end
            end
        end                

    end
end
