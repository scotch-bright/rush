module Rush

  class PageMaker

    attr_reader :data

  	def initialize(config)
      @config = config
  		@pages_folder = config.pages_folder
  		@headers_folder = config.headers_folder
  		@partials_folder = config.partials_folder
  		@data_folder = config.data_folder
  		@layouts_folder = config.layouts_folder
  	end

  	def get_page(path)
      begin
        parse_data_folder
      rescue Exception => e
        es = Rush::ErrorServer.new e
        es.get_error_html
      end
  	end

    private
    def parse_data_folder
      dp = Rush::DataPuller.new(@config)
      if !dp.well_formed?
        # Raise the DataFolderParseError and pass the error
        raise Rush::DataFolderParseError.new(Rush::ERROR_TITLE_MALFORMED_JSON, dp.errors, Rush::ERROR_DESC_MALFORMED_JSON)
      else
        @data = dp.data
      end
    end

    def log(title, msg)
      puts "\n\n\n" + "=" * 10 + title + "=" * 10 + "\n" + msg + "=" * 20 + "\n\n\n"
    end

  end

  class PageMakerError < StandardError
    attr_reader :long_error_description
    def initialize(msg, long_error_description)
      @long_error_description = long_error_description
      super(msg)
    end
  end

  class DataFolderParseError < StandardError
    attr_reader :long_error_description, :errors_array
    def initialize(msg, errors_array, long_error_description)
      @errors_array = errors_array
      @long_error_description = long_error_description
      super(msg)
    end
  end

end
