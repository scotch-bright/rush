# require 'spec_helper'
# require 'rush'

# describe Rush::PageMaker do

#   TEST_FIXTURES_FOLDER_PATH = File.expand_path( "../test_fixtures/page_maker_test", __FILE__ )

#   def setup_page_maker(hash_of_folders)
#   	mock_config = OpenStruct.new(hash_of_folders)
#   	Rush::PageMaker.new(mock_config)
#   end

#   let (:all_folders_exist_pm) { setup_page_maker ( { view_folder: File.join ( TEST_FIXTURES_FOLDER_PATH, ""), layouts_folder: "", partials_folder: "", data_folder: "" } ) }

#   describe "#initalize" do

#   	context "the expected folders dont exist in the context" do

#     end

#     context "all the folders exist" do

#     end

#   end

# end