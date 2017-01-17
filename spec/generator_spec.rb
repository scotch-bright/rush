require "spec_helper"
require "rush"

describe Rush::Generator do

  before (:each) do
    FileUtils.rm_rf(File.join(test_folder, "new_app"))
    FileUtils.rm_rf(File.join(test_folder, "exists"))
    Dir.mkdir File.join(test_folder, "exists")

    file_that_should_be_there = File.join(test_folder, "exists", "test.txt")
    File.open(file_that_should_be_there, "w+") do |file|
      file.write("this is a test!")
    end
  end

  let (:test_folder) { File.expand_path( "../test_fixtures/generator_test", __FILE__ ) }

  def is_folder_as_required folder_path
  	[
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "pages") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "headers") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "partials") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "layouts") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "data") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "css") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "js") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "images") ,
  	Rush::FileFetcher.directory_exists?(File.join folder_path, "static_files")
    ].all?
  end

  describe ".make_project" do

  	context "a folder already exists with the same name" do

  		it "deletes the folder and makes a fresh one" do
        project_path = File.join test_folder, "exists"
  			Rush::Generator.new(project_path).make_project
        is_folder_as_required(project_path).should be true
        Rush::FileFetcher.file_exists?(File.join project_path, "test.txt").should be false
  		end

  	end

  	context "a folder does not exist with the same name" do

  		it "makes a fresh folder with the entire structure" do
        project_path = File.join test_folder, "new_app"
        Rush::Generator.new(project_path).make_project
        is_folder_as_required(project_path).should be true
  		end

  	end
 
  end

end
