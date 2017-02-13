require 'yaml'

module Rush

  class Application

    attr_reader :config, :css_server, :js_server, :page_maker

    def initialize(app_path)
      @bad_config = false
      @app_path = app_path
      set_up_config
      set_up_servers
    end

    # Rack app interface
    def call(env)
      unless @bad_config
        request = Rack::Request.new(env)
        path = request.path
        if path.start_with?("/css/")
          @css_server.call(env)
        elsif path.start_with?("/js/")
          @js_server.call(env)
        elsif path.start_with?("/images/") || path.start_with?("/static_files/") || path.start_with?("/fonts/")
          @static_server.call(env)
        else
          @page_maker.call(env)
        end
      else
        ['500', {'Content-Type' => 'text/html'}, [@error_html]]
      end
    end

    private
    def set_up_servers
      @css_server = Rush::CSSServer.new @config
      @js_server = Rush::JSServer.new @config
      @page_maker = Rush::PageMaker.new @config
      @static_server = Rack::Directory.new @app_path
    end

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

    def parse_yamls_and_add_to_config
      yaml_file_path = File.join @app_path, "rush_config.yml"
      if Rush::FileFetcher.file_exists? yaml_file_path
        begin
          config = YAML.load_file(yaml_file_path)
          config.each do |key, val|
            @config[key.to_sym] = val
          end
        rescue
          # Produce error HTML and keep. We will use this in our Rack app when needed
          es = Rush::ErrorServer.new(Rush::RushError.new(Rush::ERROR_TITLE_YAML_CONFIG_PARSE_ERROR, Rush::ERROR_DESC_YAML_CONFIG_PARSE_ERROR))
          @error_html = es.get_error_html
          @bad_config = true
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
