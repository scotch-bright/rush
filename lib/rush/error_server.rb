require 'erb'

module Rush

  class ErrorServer

    def initialize(error)
      @error = error
      @path_to_templates_folder = File.expand_path( "../../templates", __FILE__ )
      setup_instance_variables_based_on_error_type
    end

    def get_error_html
      error_template = Rush::FileFetcher.get_file_contents( File.join( @path_to_templates_folder, "error.html.erb" ) )
      ERB.new(error_template).result(binding)
    end

    private
    def setup_instance_variables_based_on_error_type
      case @error
      when Rush::PageMakerError
        @error_title = @error.message
        @error_description = @error.long_error_description
        @error_additional_details = ""
      when Rush::DataFolderParseError
        @error_title = @error.message
        @error_description = @error.long_error_description
        @errors_array = @error.errors_array
        @error_additional_details = get_data_parsing_error_table
      else
        @error_title = Rush::ERROR_TITLE_GENERAL_RUBY_ERROR
        @error_description = @error.message
        @error_additional_details = ""
      end
    end

    def get_data_parsing_error_table
      datapuller_bad_json_table_template = Rush::FileFetcher.get_file_contents( File.join( @path_to_templates_folder, "json_parsing_error_template.html.erb" ) )
      ERB.new(datapuller_bad_json_table_template).result(binding)
    end

  end

end
