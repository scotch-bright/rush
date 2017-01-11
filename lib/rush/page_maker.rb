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

end
