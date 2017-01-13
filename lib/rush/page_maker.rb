module Rush

  class PageMaker

  	def initialize(config)
  		@pages_folder = config.pages_folder
  		@headers_folder = config.headers_folder
  		@partials_folder = config.partials_folder
  		@data_folder = config.data_folder
  		@layouts_folder = config.layouts_folder
  	end

  	def get_page(path)
  		""
  	end

  end

  class ResourceNotFoundError < StandardError
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
