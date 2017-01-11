require 'spec_helper'
require 'rush'

describe Rush::PageMaker do

  let (:test_fixtures_folder_path) { File.expand_path( "../test_fixtures/page_maker_test", __FILE__ ) }

  def get_page_maker_from_folder_path(folder_path)
    app_folder = File.join(test_fixtures_folder_path, folder_path)
    pages_folder = File.join( app_folder, "pages" )
    headers_folder = File.join( app_folder, "headers" )
    partials_folder = File.join( app_folder, "partials" )
    data_folder = File.join( app_folder, "data" )
    layouts_folder = File.join( app_folder, "layouts" )
    pm = Rush::PageMaker.new(
      OpenStruct.new(
        pages_folder: pages_folder,
        headers_folder: headers_folder,
        partials_folder: partials_folder,
        data_folder: data_folder,
        layouts_folder: layouts_folder
      )
    )
    expected_result = Rush::FileFetcher.get_file_contents( File.join(app_folder, "expected_text.txt") )
    result_got = pm.get_page("welcome")
    return { expected: expected_result, got: result_got }
  end

  describe "#get_page" do

    context "the data puller initialization raises an error" do

      it "shows the data puller errors in a frindly way" do
        folder_name = "data_puller_error"
        result_hash = get_page_maker_from_folder_path(folder_name)
        result_hash[:expected].should == result_hash[:got]
      end

    end

    context "the data puller initialization does not raise an error" do

      it "allows views and partials to acess the data from data puller properly" do
        folder_name = "data_puller_good"
        result_hash = get_page_maker_from_folder_path(folder_name)
        result_hash[:expected].should == result_hash[:got]
      end

    end

    context "there is a html file with the same name as the page in the headers folder" do

      context "there is a call to 'render_header' at some point in the page" do

        it "renders the header in the correct place" do
          folder_name = "test_render_header"
          result_hash = get_page_maker_from_folder_path(folder_name)
          result_hash[:expected].should == result_hash[:got]
        end

      end

    end

    context "the view was not found in the view folder" do

      context "the 404 view was not found in the errors folder" do

        it "returns a page with the view being an H1 with 404 not found as the view" do
          folder_name = "no_view_no_errors_folder"
          result_hash = get_page_maker_from_folder_path(folder_name)
          result_hash[:expected].should == result_hash[:got]
        end

      end

      context "the 404 view was found in the error folder" do

        it "gets 404 as the view" do
          folder_name = "no_view_404_present"
          result_hash = get_page_maker_from_folder_path(folder_name)
          result_hash[:expected].should == result_hash[:got]
        end

      end

    end

    context "the view was found in the view folder" do

      context "the layout includes partials via a call to render_partial 'partial_file_name'" do

        context "the partial was found in the partials folder" do

          it "renders the partial at the appropriate spot" do
            folder_name = "view_calls_for_partial"
            result_hash = get_page_maker_from_folder_path(folder_name)
            result_hash[:expected].should == result_hash[:got]
          end

        end

        context "the partial was not found in the partial folder" do

          it "raises a friendly error message letting the user know how to solve the issue" do
            folder_name = "view_calls_for_partial_missing_partial"
            result_hash = get_page_maker_from_folder_path(folder_name)
            result_hash[:expected].should == result_hash[:got]
          end

        end

      end

      context "the first line of the view is a comment which has set_layout:'<layout_file_name>'" do

        context "the layout file name as specified in the comment was found in the layouts folder" do

          it "uses the layout other than the default layout of 'application.html' as specified in the comment" do
            folder_name = "specific_layout"
            result_hash = get_page_maker_from_folder_path(folder_name)
            result_hash[:expected].should == result_hash[:got]
          end

        end

        context "the layout file name as specified in the comment was not found in the layouts folder" do

          it "raises a friendly error letting the user know that there is no file like '<layout_file_name>.html in the layouts folder'" do
            folder_name = "specific_layout_not_found"
            result_hash = get_page_maker_from_folder_path(folder_name)
            result_hash[:expected].should == result_hash[:got]
          end

        end

      end

      context "there is no comment in the first line with the text set_layout:'<layout_file_name>'" do

        context "there is no file called 'application.html' in the layouts folder" do

          it 'raises a friendly error to the user letting him know that there needs to be a file called application.html in the layouts folder' do
            folder_name = "standard_layout_not_found"
            result_hash = get_page_maker_from_folder_path(folder_name)
            result_hash[:expected].should == result_hash[:got]
          end

        end

        context "there is a file called 'application.html' in the layouts folder" do

          context "the layout does not make any call to the 'render_page' method via ERB" do

            it "raises a friendly error reminding the developer that he/she should make a call to 'render_page' or the view will not show up" do
              folder_name = "standard_layout_no_render_view"
              result_hash = get_page_maker_from_folder_path(folder_name)
              result_hash[:expected].should == result_hash[:got]
            end

          end

          context "the layout makes a call to the 'render_page' method via ERB" do

            it "renders the layout with the application.html as the layout" do
              folder_name = "standard_layout_found"
              result_hash = get_page_maker_from_folder_path(folder_name)
              result_hash[:expected].should == result_hash[:got]
            end

          end

        end

      end

    end

  end

end
