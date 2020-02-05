require 'spec_helper'

module Vstool
    describe MedusaSync do
        describe "#new" do
            subject { MedusaSync.new(params) }
            let(:output) { double('output').as_null_object }
            let(:params) { {:output => output}}
            let(:app) { MedusaSync.new(params) }
            it "with output" do
                expect{ subject }.not_to raise_error
            end
        end

        describe "run_import" do
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

        describe "import" do
            skip "is skipped" do
            before(:each) do
                VisualStage::Base.clean
                dir = "tmp"	
                deleteall(dir) if File.directory?(dir)
                Dir.mkdir(dir) unless File.directory?(dir)
                setup_data(vs_dir)
            end
            subject { app.import(vs_dir, surface_name) }
            let(:app) { MedusaSync.new(params) }
            let(:params){ {} }
            let(:surface_name){ "BCG12-#{random_number(4)}" }
            let(:vs_dir) { 'tmp/BCG12-with-ID' }
            it { expect{ subject }.not_to raise_error } 
        end 
        end

        describe "run_checkout" do
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
                    app.should receive(:checkout).with("surface_id", "vs_dir")
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

        describe "checkout" do
            skip "is skipped" do
            before(:each) do
                VisualStage::Base.clean
                dir = "tmp"	
                deleteall(dir) if File.directory?(dir)
                Dir.mkdir(dir) unless File.directory?(dir)
            end    
            subject { app.checkout(surface_id, vs_dir) }
            let(:app) { MedusaSync.new(params) }
            let(:params){ {} }
            let(:surface_id){ "20191008162241-096894" }
            let(:vs_dir) { 'tmp/sync_test' }
            it { expect{ subject }.not_to raise_error }  
        end

        describe "run_update" do
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
        end                

        describe "run_commit" do
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
