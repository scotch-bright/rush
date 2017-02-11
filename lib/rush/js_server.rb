require 'uglifier'

module Rush

  class JSServer < AssetsServer

    attr_reader :folder_path, :minify

    def initialize(config)
      @folder_path = config.js_folder
      @minify = config.minify_js == true ? true : false
    end

    def get_js_file file_name, production=nil
      get_file file_name, production
    end

    private

    def minify_this js_content
      Uglifier.new.compile(js_content)
    end

    def get_mime_type
      'application/javascript'
    end

    def get_404_message
      Rush::JS_SERVER_404_MESSAGE
    end

    def convert_path_to_file_call path
      path.gsub("/js/", "")
    end

  end

end

