require 'json'

module Rush

  # == User Requirement Catered To
  # Almost every static site, has some structured data. For Example: Menus and sub-menus, list of articles, products, items etc. There should be a way in which the developer can specify some structured data. This data should be accessible by the views, layouts and partials. This data can be used in combination with ERB to help the developer write DRY HTML code.
  class DataPuller

    attr_reader :errors, :data

    def initialize(config)
      @data_folder = config.data_folder
      if Rush::FileFetcher.directory_exists?(@data_folder)
        @data = OpenStruct.new
        @well_formed = true
        @errors = []
        process_data_folder
      else
        raise Rush::DataFolderNotFound, "There does not seem to be a folder at path: #{@data_folder}"
      end
    end

    # Returns if the data was well formed in all the files in the "data" folder.
    def well_formed?
      @well_formed
    end

    private
    def process_data_folder
      Rush::FileFetcher.array_of_file_paths(@data_folder).each do |data_file_path|
        file_json = Rush::FileFetcher.get_file_contents data_file_path
        begin
          file_name_without_extension = Rush::FileFetcher.get_file_name_from_path(data_file_path)
          @data[file_name_without_extension] = JSON.parse(file_json, object_class: OpenStruct)
        rescue JSON::ParserError => e
          @well_formed = false
          @errors << { data_file_path => remove_error_code_from_JSON_error(e.message) }
        end
      end
    end

    def remove_error_code_from_JSON_error(error_message)
      error_message.gsub(/\d+: /, "")
    end

  end

  class DataFolderNotFound < StandardError
  end

end
