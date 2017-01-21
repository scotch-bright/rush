require "spec_helper"
require "rush"

describe Rush::Make do

  let (:sample_rush_project_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app", __FILE__ ) }

  let (:made_project_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static", __FILE__ )  }
  let (:made_project_css_folder_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static/css", __FILE__ )  }
  let (:made_project_js_folder_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static/js", __FILE__ )  }
  let (:made_project_welcome_folder_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static/welcome", __FILE__ )  }

  def make_rush_app project_path
    rush_maker = Rush::Make.new sample_rush_project_path
    rush_maker.make_project
  end

  describe "#make_project" do

    after(:all) do
      FileUtils.rm_rf(made_project_path)
    end

    context "there was no folder found at the path" do

      it "raises an error with the appropriate error message" do
      end

    end

    context "there was no pages folder found at the path" do

      it "raises an error with the appropriate error message" do
      end

    end

    context "the pages folder was found at the path" do

      context "the pages folder does not contain any files" do

        it "raises an error with the appropriate error message" do
        end

      end

      context "the pages folder contains files" do

        context "the pages folder contains a file called 'index.html'" do

          context "the css folder contains a file called 'test.scss'" do

            it "creates a css folder with a file called 'test.css' in it with the scss conerted to css" do
            end

          end

          context "the js folder contains a file called 'test.coffee'" do

            it "creates a js folder with a file called 'test.js' in it with the coffee conerted to js" do
            end

          end

          it "creates a css folder with a file called 'application.css' in it" do
          end

          it "creates a file in the root folder of the output folder called 'index.html'" do
          end

          it "changes the file names in HTML of the '.scss' files to '<HASH_SIGNITURE>.css' files" do
          end

          it "changes the file names in HTML of the '.coffee' files to '<HASH_SIGNITURE>.js' files" do
          end

          context "the pages folder contains files other than index.html" do

            context "the other file is called 'welcome.html'" do

              it "creates a folder called 'welcome' in the root folder" do
              end

              it "creates a file called 'index.html' in the welcome folder" do
              end

              it "changes the file names in HTML of the '.scss' files to '.css' files" do
              end

              it "changes the file names in HTML of the '.coffee' files to '.js' files" do
              end

              it "changes the file names path from '/css/css_file.css' to '../css/css_file_<HASH_SIGNITURE>.css' in HTML" do
              end

              it "changes the file names path from '/js/js_file.js' to '../js/js_file_<HASH SIGNITURE>.js' in HTML" do
              end

              it "changes the file names path from '/images/image_file.jpeg' to '../images/image_file_<HASH SIGNITURE>.jpeg' in HTML" do
              end

              it "changes the file names path from '/static_files/file_name.pdf' to '../static_files/file_name_<HASH SIGNITURE>.pdf' in HTML" do
              end

            end

          end

        end

        context "the pages folder does not contain a file called 'index.html'" do

	      it "raises an error with the appropriate error message" do
	      end

        end

      end

    end

  end

end
