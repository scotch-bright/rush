require "rack"
require "spec_helper"
require "rush"

describe Rush::Application do

  let (:test_fixtures_folder_path) { File.expand_path( "../test_fixtures/application_test/rashidas_website", __FILE__ ) }
  let (:application) { Rush::Application.new test_fixtures_folder_path }
  let (:mock_request) { Rack::MockRequest.new application.rack_app }

  describe "#config" do

    it "gives the path of the various folders that should be making up the rush application" do
      application.config.pages_folder.to == File.join(test_fixtures_folder_path, "pages")
      application.config.headers_folder.to == File.join(test_fixtures_folder_path, "headers")
      application.config.partials_folder.to == File.join(test_fixtures_folder_path, "partials")
      application.config.layouts_folder.to == File.join(test_fixtures_folder_path, "layouts")
      application.config.data_folder.to == File.join(test_fixtures_folder_path, "data")
      application.config.css_folder.to == File.join(test_fixtures_folder_path, "css")
      application.config.js_folder.to == File.join(test_fixtures_folder_path, "js")
    end

    it "adds the keys and values that are mentioned in the rush_config.yml file if the rush_config.yml exists" do
      application.config.minify_js.to == true
      application.config.minify_css.to == false
      application.config.app_name.to == "Rashida's Website"
    end

  end

  describe "#rack_app" do

    context "if a the path is like /css/some_css_file.css" do

      it "responds to calls via the CSS server" do
        mock_request.get("/css/1.css").body.to == "hi{color:red}"
      end

      it "responds with content type 'text/css'" do
        mock_request.get("/css/1.css").content_type.to == "text/css"
      end

    end

    context "if a the path is like /js/some_js_file.js" do

      it "responds to calls via the JS server" do
        mock_request.get("/js/1.js").body.to == "var a=!1;"
      end

      it "responds with content type 'application/javascript'" do
        mock_request.get("/js/1.js").content_type.to == "application/javascript"
      end

    end

    context "images or static files are asked for" do

      it "renders images when called by '/images/image_file_name.jpeg'" do
        mock_request.get("/images/test.jpeg").content_type.to == "image/jpeg"
      end

      it "renders static files when called by '/static_files/static_file_name.pdf'" do
        mock_request.get("/static_files/test.pdf").content_type.to == "application/pdf"
      end

    end

    context "something that is not present is asked for" do

      it "responds with a 404" do
        mock_request.get("/static_files/file_not_there.jpeg").not_found?.to == true
        mock_request.get("/css/not_there.css").not_found?.to == true
        mock_request.get("/js/not_there.js").not_found?.to == true
        mock_request.get("/images/not_there.jpeg").not_found?.to == true
      end

    end

    context "an HTML page is asked for" do

      context "the page can be sucessfully displayed" do

        it "responds with the HTML" do
          mock_request.get("/welcome").body.to == "it works!"
        end

        it "responds content_type 'text/html'" do
          mock_request.get("/welcome").content_type.to == "text/html"
        end

      end

      context "the page cannot be sucessfully displayed due to some error" do

        it "responds with the a 500 code and the error message" do
          mock_request.get("/not_present").server_error?.to == true
        end

      end

    end

  end

end
