require "spec_helper"
require "rush"

describe Rush::JSServer do

  describe "#get_js_file" do

    let (:js_test_folder) { File.expand_path( "../test_fixtures/js_server_test", __FILE__ ) }
    
    let (:js_server) {
      Rush::JSServer.new(OpenStruct.new(js_folder: js_test_folder))
    }

    let (:js_server_for_application_js_test) {
      Rush::JSServer.new(OpenStruct.new(js_folder: File.join( js_test_folder, "application_js_test")))
    }

    let (:js_server_with_minification) {
      Rush::JSServer.new(OpenStruct.new(js_folder: js_test_folder, minify_js: true))
    }

    context "minify flag is set to true" do

      it "minifies the js files before returning the final output" do
        the_js_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(js_test_folder, "test_minified.js"))
        expect (js_server_with_minification.get_js_file("test.js")).should eq the_js_that_should_be_returned
      end

    end

    context "the js file exists in the js folder" do

      context "the js file name ends in .coffee" do

        it "converts coffee script to js and returns it" do
          the_js_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(js_test_folder, "coffee_test_result.js"))
          expect (js_server.get_js_file("coffee_test.coffee")).should eq the_js_that_should_be_returned
        end

      end

      context "its a normal js file with ending in .js" do

        it "returns the js file found in the folder" do
          the_js_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(js_test_folder, "test.js"))
          expect (js_server.get_js_file("test.js")).should eq the_js_that_should_be_returned
        end

      end

    end

    context "the js file does not exist in the js folder" do

      context "the js file asked for is 'application.js'" do

        context "the js folder contains both .js and .coffee files" do

          it "combines the .js files and .coffee outputs and merges them into a single .js file in alphabetical order" do
            the_js_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(js_test_folder, "combined_application.js"))
            expect (js_server_for_application_js_test.get_js_file("application.js")).should eq the_js_that_should_be_returned
          end

        end

      end

      context "the .js file asked for is not 'application.js'" do

        it "returns a blank string" do
          expect (js_server.get_js_file("not_present.js")).should eq ""
        end

      end

    end

  end


end
