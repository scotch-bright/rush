module Rush

  class CSSServer < AssetsServer

    attr_reader :folder_path, :minify

    def initialize(config)
      @folder_path = config.css_folder
      @minify = config.minify_css == true ? true : false
    end

    def get_css_file css_file_name
      get_file css_file_name
    end

    private

    def get_mime_type
      'text/css'
    end

    def get_404_message
      Rush::CSS_SERVER_404_MESSAGE
    end

    def convert_path_to_file_call path
      path.gsub("/css/", "")
    end

    def minify_this input
      Rush::CSSMinifier.minify_this input
    end

  end

end
