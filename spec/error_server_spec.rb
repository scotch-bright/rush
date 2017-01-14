require "spec_helper"
require "rush"

describe Rush::ErrorServer do

  describe "#get_error_html" do

    context "resource missing" do

      it "returns HTML error indicating the same" do
        es = Rush::ErrorServer.new(Rush::PageMakerError.new("application.html missing in layouts folder", "user/path/application.html"))
        expect(es.get_error_html).to include("Rush Error", "application.html missing in layouts folder", "user/path/application.html")
        es.get_error_html.should_not include("<table>")
      end

    end

    context "JSON parse error was returned by the DataPuller and got the errors array" do

      it "returns HTML error indicating the same" do
        json_parse_errors_array = [ { file: "/bad/json.json", error_message: "unexpected token at '}'" }, { file: "/horrible/bad/json.json", error_message: "unexpected token at '}{}'" } ]
        es = Rush::ErrorServer.new(Rush::DataFolderParseError.new("JSON is Malformed", json_parse_errors_array, "long winded description of how the json is malformed" ))
        expect(es.get_error_html).to include("Rush Error", "JSON is Malformed", "<table>", "unexpected token at '}'", "long winded description")
      end

    end

    context "erb passing error or any other form of error" do

      it "returns HTML error indicating the same" do
        es = Rush::ErrorServer.new(StandardError.new("application.html missing in layouts folder"))
        expect(es.get_error_html).to include("Rush Error", "application.html missing in layouts folder")
        es.get_error_html.should_not include("<table>")
      end

    end

  end

end
