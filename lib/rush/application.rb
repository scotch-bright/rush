require 'yaml'

module Rush

  class Application
    
  	attr_reader :config

  	def initialize(app_path)
  		@error_html = nil
  		@app_path = app_path
  		set_up_config
  	end

  	def rack_app
  		nil
  	end

  	private
  	def set_up_config
  		@config = OpenStruct.new(
  			pages_folder: File.join(@app_path, "pages"),
  			headers_folder: File.join(@app_path, "headers"),
  			partials_folder: File.join(@app_path, "partials"),
  			layouts_folder: File.join(@app_path, "layouts"),
  			data_folder: File.join(@app_path, "data"),
  			css_folder: File.join(@app_path, "css"),
  			js_folder: File.join(@app_path, "js")
  		)
  		parse_yamls_and_add_to_config
  	end

  	private

  	def parse_yamls_and_add_to_config
  		yaml_file_path = File.join @app_path, "rush_config.rb"
  		if Rush::FileFetcher.file_exists? yaml_file_path
  			begin
  				config = YAML.load_file(yaml_file_path)
				config.each do |key, val|
					@config[key.to_sym] = val
				end
  			rescue
  				# Produce error HTML and keep. We will use this in our Rack app when needed
  				es = Rush::ErrorServer.new ( Rush::RushError.new Rush::ERROR_TITLE_YAML_CONFIG_PARSE_ERROR, Rush::ERROR_DESC_YAML_CONFIG_PARSE_ERROR )
  				@error_html = es.get_error_html
  			end
  		end
  	end

  end

  class RushError < StandardError
    attr_reader :long_error_description
    def initialize(msg, long_error_description)
      @long_error_description = long_error_description
      super(msg)
    end
  end

end

