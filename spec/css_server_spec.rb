require "spec_helper"
require "rush"

describe Rush::CSSServer do

  describe "#get_css_file" do

    let (:css_test_folder) { File.expand_path( "../test_fixtures/css_server_test", __FILE__ ) }
    let (:css_server) {
      Rush::CSSServer.new(OpenStruct.new(css_folder: css_test_folder))
    }

    let (:css_server_for_application_css_test) {
      Rush::CSSServer.new(OpenStruct.new(css_folder: File.join( css_test_folder, "aplication_css_test")))
    }

    let (:css_server_with_minification) {
      Rush::CSSServer.new(OpenStruct.new(css_folder: css_test_folder, minify_css: true))
    }

    context "minify flag is set to true" do

      it "minifies the css files before returning the final output" do
        the_css_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(css_test_folder, "test_minified.css"))
        expect (css_server_with_minification.get_css_file("test.css")).should eq the_css_that_should_be_returned
      end

    end

    context "the css file exists in the css folder" do

      context "the css file name ends in .scss" do

        it "converts scss to css and returns it" do
          the_css_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(css_test_folder, "test.css"))
          expect (css_server.get_css_file("test.scss")).should eq the_css_that_should_be_returned
        end

      end

      context "its a normal css file with ending in .css" do

        it "returns the css file found in the folder" do
          the_css_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(css_test_folder, "test.css"))
          expect (css_server.get_css_file("test.css")).should eq the_css_that_should_be_returned
        end

      end

    end

    context "the css file does not exist in the css folder" do

      context "the css file asked for is 'application.css'" do

        context "the css folder contains both css and scss files" do

          it "combines the css files and scss outputs and merges them into a single css file in alphabetical order" do
            the_css_that_should_be_returned = Rush::FileFetcher.get_file_contents(File.join(css_test_folder, "application_css_test_result.css"))
            expect (css_server_for_application_css_test.get_css_file("application.css")).should eq the_css_that_should_be_returned
          end

        end

      end

      context "the css file asked for is not 'application.css'" do

        it "returns a blank string" do
          expect (css_server.get_css_file("not_present.css")).should eq ""
        end

      end

    end

  end

end
