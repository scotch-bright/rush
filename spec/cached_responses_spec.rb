require 'spec_helper'
require 'rush'

describe Rush::CachedResponse do

  before (:each) do
    FileUtils.rm_rf(File.join(test_fixtures_folder_path, "test_app_no_temp_folder"))
    Dir.mkdir File.join(test_fixtures_folder_path, "test_app_no_temp_folder")

    file_that_should_have_yay = File.join(test_fixtures_folder_path, "test_app_with_temp_folder", "temp", "welcome.txt")
    File.open(file_that_should_have_yay, "w+") do |file|
      file.write("yay")
    end
  end

  def make_cached_responses_obj(app_folder)
    app_folder_path = File.join(test_fixtures_folder_path, app_folder)
    config = OpenStruct.new(application_folder: app_folder_path)
    Rush::CachedResponse.new(config)
  end

  let (:test_fixtures_folder_path) { File.expand_path( "../test_fixtures/cached_responses_test", __FILE__ ) }
  
  let (:cached_responses_obj_no_temp_folder) { make_cached_responses_obj("test_app_no_temp_folder") }
  let (:cached_responses_obj) { make_cached_responses_obj("test_app_with_temp_folder") }

  describe "#get_data_by_key" do

    context "the temp folder does not exist in the application root" do

      it "returns nil" do
        expect(cached_responses_obj_no_temp_folder.get_data_by_key("welcome")).to be_nil
      end

    end

    context "the temp folder exists in the application root" do

      context "the file with key name was found in the temp folder" do

        it "returns the contents of the file" do
          expect(cached_responses_obj.get_data_by_key("welcome")).to eq("yay")
        end

      end

      context "the file with the key name was not found in the temp folder" do

        it "returns nil" do
          expect(cached_responses_obj.get_data_by_key("not_there")).to be_nil
        end

      end

    end

  end

  describe "#set_data_by_key" do

    context "the temp folder does not exist in the application root" do

      it "creates the temp folder and saves a file in the format <key>.txt with the contents passed as the second argument" do
        cached_responses_obj_no_temp_folder.set_data_by_key("welcome", "test")
        expect(Rush::FileFetcher.get_file_contents(File.join(test_fixtures_folder_path, "test_app_no_temp_folder", "temp", "welcome.txt"))).to eq "test"
      end

    end

    context "the temp folder exists in the application root" do

      context "the file already exists" do

        it "overwrites the contents of <key>.txt with the contents of the second paramter" do
          cached_responses_obj.set_data_by_key("welcome", "overwritten")
          expect(Rush::FileFetcher.get_file_contents(File.join(test_fixtures_folder_path, "test_app_with_temp_folder", "temp", "welcome.txt"))).to eq "overwritten"
        end

      end

      context "the file does not exist" do

        it "creates a new file with the format <key>.txt and saves it" do
          cached_responses_obj.set_data_by_key("not_present", "yay")
          expect(Rush::FileFetcher.get_file_contents(File.join(test_fixtures_folder_path, "test_app_with_temp_folder", "temp", "not_present.txt"))).to eq "yay"
        end

      end

    end

  end

end