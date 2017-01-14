require 'spec_helper'
require 'rush'

describe Rush::FileFetcher do

  let ( :test_fixtures_folder_path ) { File.expand_path( "../test_fixtures/file_fetcher_test", __FILE__ ) }

  describe ".array_of_file_paths" do

    context "files are present in the folder" do
      it "returns an array of file paths ordered by names of files in alphabetical order" do
        folder = File.join( test_fixtures_folder_path, "lots_of_files")
        expect Rush::FileFetcher.array_of_file_paths(folder).should =~ [File.join(folder, "1.html"), File.join(folder, "1a.html"), File.join(folder, "2.rb"), File.join(folder, "a.html")]
      end
    end

    context "files are no present in the folder" do
      it "returns nil" do
        folder = File.join( test_fixtures_folder_path, "no_files_folder")
        expect Rush::FileFetcher.array_of_file_paths(folder).should =~ []
      end
    end

  end

  describe ".first_line_of_file" do

    it "returns a string containing the first line of the file" do
      file_path = File.join( test_fixtures_folder_path, "lots_of_files", "1a.html")
      expect Rush::FileFetcher.first_line_of_file(file_path).should eq "<b>One more file!</b>\n"
    end

  end

  describe ".get_file_contents" do

    it "gets the contents of the file" do
      file_path = File.join( test_fixtures_folder_path, "lots_of_files", "1.html")
      expect Rush::FileFetcher.get_file_contents(file_path).should eq "<h1>Yay!</h1>"
    end

  end

  describe ".get_file_name_from_path" do

    it "gets file name from the full file path" do
      file_path = File.join( test_fixtures_folder_path, "lots_of_files", "1.html.erb")
      file_path_1 = File.join( test_fixtures_folder_path, "lots_of_files", "2a.erb")
      file_path_2 = File.join( test_fixtures_folder_path, "lots_of_files", "3b")
      expect Rush::FileFetcher.get_file_name_from_path(file_path).should eq "1"
      expect Rush::FileFetcher.get_file_name_from_path(file_path_1).should eq "2a"
      expect Rush::FileFetcher.get_file_name_from_path(file_path_2).should eq "3b"
    end

  end

  describe ".file_exists?" do

    context "the file exists" do

      it "returns true" do
        file_path = File.join(test_fixtures_folder_path, "lots_of_files", "1.html")
        does_file_exist = Rush::FileFetcher.file_exists?(file_path)
        expect(does_file_exist).to be true
      end

    end

    context "the file does not exist" do

      it "returns false" do
        expect(Rush::FileFetcher.file_exists?(File.join( test_fixtures_folder_path, "lots_of_files", "not_there.html"))).to be false
      end

    end

  end

  describe ".get_file_name_and_extension_from_path" do

    it "returns file name and extension" do
      file_path = File.join(test_fixtures_folder_path, "lots_of_files", "1.html")
      output = Rush::FileFetcher.get_file_name_and_extension_from_path(file_path)
      expect output.should eq "1.html"
    end

  end

  describe ".directory_exists?" do

    context "the folder path exists" do

      it "returns true" do
        expect Rush::FileFetcher.directory_exists?(File.join( test_fixtures_folder_path, "lots_of_files")).should eq true
      end

    end

    context "the folder path does not exist" do

      it "returns false" do
        expect Rush::FileFetcher.directory_exists?(File.join( test_fixtures_folder_path, "not_there")).should eq false
      end

    end

  end


end
