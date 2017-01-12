require "spec_helper"
require 'rush'

describe Rush::DataPuller do

  def make_data_puller_based_on_folder_path(folder_path)
    cf = Struct.new(:data_folder).new
    cf.data_folder = folder_path
    Rush::DataPuller.new(cf)
  end

  let (:test_fixtures_folder_path) { File.expand_path( "../test_fixtures/data_puller_test", __FILE__ ) }

  let (:well_formed_json_path) { File.join( test_fixtures_folder_path, "data_well_formed_json") }
  let (:mal_formed_json_path) { File.join( test_fixtures_folder_path, "badly_formed_json")  }

  let (:well_formed_json_dp) { make_data_puller_based_on_folder_path(well_formed_json_path) }
  let (:mal_formed_json_dp) { make_data_puller_based_on_folder_path(mal_formed_json_path) }

  describe "#initialize" do

    context "the data folder in the config does not exist" do

      it "raises DataFolderNotFound error" do
        expect { Rush::DataPuller.new(OpenStruct.new(data_folder: "/Users/khojbadamo")) }.to raise_error(Rush::DataFolderNotFound)
      end

    end

  end

  describe "#well_formed?" do

    context "when json files are malfolmed" do
      it "returns false if json files are malfolmed" do
        expect mal_formed_json_dp.well_formed?.should be false
      end
    end

    context "when json files are well formed" do
      it "returns true if json files are wellformed" do
        expect well_formed_json_dp.well_formed?.should be true
      end
    end

  end


  describe "#errors" do

    context "when json files are malfolmed" do
      it "returns an array of hashes with file names as the key and error from the JSON parser as the value" do
        expect mal_formed_json_dp.errors.should =~ [ { file: File.join(mal_formed_json_path, "bad_json.json"), error_message: "unexpected token at '}'" }, { file: File.join(mal_formed_json_path, "bad_json_2.json"), error_message: "unexpected token at '}{}'" } ]
      end
    end

    context "when json files are well formed" do
      it "returns nil" do
        expect well_formed_json_dp.errors.should =~ []
      end
    end

  end

  describe "#data" do

    it "converts files that end with the .json into a ruby object that can be acessed using '.' notation" do
      expect well_formed_json_dp.data.test.this.should eq "that"
      expect well_formed_json_dp.data.two.two.should eq 2
      expect well_formed_json_dp.data.two.array_of_thee.should =~ [1, 2, 3]
      expect well_formed_json_dp.data.two.another_object.sub_object_property.should eq "this"
      expect well_formed_json_dp.data.two.another_object.sub_object_property_2.should =~ [4, 3, 2, 1]
    end

  end

end



