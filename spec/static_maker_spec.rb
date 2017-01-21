require "spec_helper"
require "rush"

describe Rush::StaticMaker do

  let (:sample_rush_project_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app", __FILE__ ) }

  let (:no_pages_folder) { File.expand_path( "../test_fixtures/maker_test/folder_without_anything", __FILE__ )  }
  let (:non_existant_folder) { File.expand_path( "../test_fixtures/maker_test/non_existant_folder", __FILE__ )  }
  let (:empty_pages_folder) { File.expand_path( "../test_fixtures/maker_test/folder_with_empty_pages_folder", __FILE__ )  }

  let (:made_project_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static", __FILE__ )  }
  let (:made_project_css_folder_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static/css", __FILE__ )  }
  let (:made_project_js_folder_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static/js", __FILE__ )  }
  let (:made_project_welcome_folder_path) { File.expand_path( "../test_fixtures/maker_test/test_rush_app_static/welcome", __FILE__ )  }

  let (:solution_project_path) { File.expand_path( "../test_fixtures/maker_test/solution", __FILE__ )  }
  let (:solution_project_css_folder_path) { File.expand_path( "../test_fixtures/maker_test/solution/css", __FILE__ )  }
  let (:solution_project_js_folder_path) { File.expand_path( "../test_fixtures/maker_test/solution/js", __FILE__ )  }
  let (:solution_project_welcome_folder_path) { File.expand_path( "../test_fixtures/maker_test/solution/welcome", __FILE__ )  }

  def make_rush_app project_path
    rush_maker = Rush::StaticMaker.new project_path
    rush_maker.make_project
  end

  describe "#make_project" do

    after(:all) do
      FileUtils.rm_rf(File.expand_path( "../test_fixtures/maker_test/test_rush_app_static", __FILE__ ))
    end

    before(:all) do
      make_rush_app File.expand_path( "../test_fixtures/maker_test/test_rush_app_static", __FILE__ )
    end

    context "there was no folder found at the path" do

      it "raises an error with the appropriate error message" do
        expect { make_rush_app non_existant_folder }.to raise_error(Rush::RushMakeError, Rush::ERROR_RUSH_MAKE_NO_FOLDER_FOUND)
      end

    end

    context "there was no pages folder found at the path" do

      it "raises an error with the appropriate error message" do
        expect { make_rush_app no_pages_folder }.to raise_error(Rush::RushMakeError, Rush::ERROR_RUSH_MAKE_NO_PAGES_FOLDER_FOUND)
      end

    end

    context "the pages folder was found at the path" do

      context "the pages folder does not contain any files" do

        it "raises an error with the appropriate error message" do
          expect { make_rush_app empty_pages_folder }.to raise_error(Rush::RushMakeError, Rush::ERROR_RUSH_MAKE_NO_PAGES_FOLDER_FOUND)
        end

      end

      context "the pages folder contains files" do

        context "the pages folder contains a file called 'index.html'" do

          context "the css folder contains a file called 'style.scss'" do

            it "creates a css folder with a file called 'style.css' in it with the scss conerted to css" do
              the_css_that_should_be_there = File.read File.join solution_project_css_folder_path, "style.css"
              the_css_that_was_found = File.read File.join made_project_css_folder_path, "style.css"
              the_css_that_was_found.should == the_css_that_should_be_there
            end

          end

          context "the js folder contains a file called 'test.coffee'" do

            it "creates a js folder with a file called 'test.js' in it with the coffee conerted to js" do
              the_js_that_should_be_there = File.read File.join solution_project_js_folder_path, "test.js"
              the_js_that_was_found = File.read File.join made_project_js_folder_path, "test.js"
              the_js_that_was_found.should == the_js_that_should_be_there
            end

          end

          it "creates a css folder with a file called 'application.css' in it" do
              the_css_that_should_be_there = File.read File.join solution_project_css_folder_path, "application.css"
              the_css_that_was_found = File.read File.join made_project_css_folder_path, "application.css"
              the_css_that_was_found.should == the_css_that_should_be_there
          end

          it "creates a js folder with a file called 'application.js' in it" do
              the_js_that_should_be_there = File.read File.join solution_project_js_folder_path, "application.js"
              the_js_that_was_found = File.read File.join made_project_js_folder_path, "application.js"
              the_js_that_was_found.should == the_js_that_should_be_there
          end

          it "creates a file in the root folder of the output folder called 'index.html'" do
              the_html_file_that_should_be_there = File.read File.join solution_project_path, "index.html"
              the_html_file_that_was_found = File.read File.join made_project_path, "index.html"
              the_html_file_that_was_found.should == the_html_file_that_should_be_there
          end

          context "the pages folder contains files other than index.html" do

            context "the other file is called 'welcome.html'" do

              it "creates a folder called 'welcome' in the root folder" do
                Rush::FileFetcher.directory_exists?(File.join(made_project_path, "welcome")).should be true
              end

              it "creates a file called 'index.html' in the welcome folder" do
                the_html_file_that_should_be_there = File.read File.join solution_project_path, "welcome", "index.html"
                the_html_file_that_was_found = File.read File.join made_project_path, "welcome", "index.html"
                the_html_file_that_was_found.should == the_html_file_that_should_be_there
              end

              it "changes the file names in HTML of the '.scss' files to '.css' files and add the '../' to the css file path" do
                the_html_file_that_was_found = File.read File.join made_project_path, "welcome", "index.html"
                expect(the_html_file_that_was_found).to include ('<link rel="stylesheet" href="../css/style.css">')
              end

              it "changes the file names in HTML of the '.coffee' files to '.js' files and add the '../' to the js file path'" do
                the_html_file_that_was_found = File.read File.join made_project_path, "welcome", "index.html"
                expect(the_html_file_that_was_found).to include ('<script src="js/test.js"></script>')
              end

              it "changes the file names path from '/images/image_file.jpeg' to '../images/image_file.jpeg' in HTML" do
                the_html_file_that_was_found = File.read File.join made_project_path, "welcome", "index.html"
                expect(the_html_file_that_was_found).to include ("<img src='../images/header.jpg'>")
              end

              it "changes the file names path from '/static_files/file_name.pdf' to '../static_files/file_name.pdf' in HTML" do
                the_html_file_that_was_found = File.read File.join made_project_path, "welcome", "index.html"
                expect(the_html_file_that_was_found).to include ("<a href='../static_files/static.pdf'>")
              end

            end

          end

        end

      end

    end

  end

end
