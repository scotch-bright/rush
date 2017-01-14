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
        @is_render_page_called = false
        parse_data_folder
        layout_template = get_layout_file(path)

        unless @is_render_page_called
          raise Rush::DataFolderParseError.new(Rush::ERROR_TITLE_NO_CALL_TO_RENDER_PAGE, Rush::ERROR_DESC_NO_CALL_TO_RENDER_PAGE)
        end

      rescue Exception => e
        es = Rush::ErrorServer.new e
        es.get_error_html
      end
    end

    private

    def render_page
      @is_render_page_called = true
      page_template = Rush::FileFetcher.get_file_contents(@page_html_path)
      ERB.new(page_template).result(binding)
    end

    def parse_data_folder
      dp = Rush::DataPuller.new(@config)
      if !dp.well_formed?
        raise Rush::DataFolderParseError.new(Rush::ERROR_TITLE_MALFORMED_JSON, dp.errors, Rush::ERROR_DESC_MALFORMED_JSON)
      else
        @data = dp.data
      end
    end

    def log(title, msg)
      puts "\n\n\n" + "=" * 10 + title + "=" * 10 + "\n" + msg + "=" * 20 + "\n\n\n"
    end

    def get_layout_file(path)
      @page_html_path = File.join @pages_folder, "#{path}.html"
      if Rush::FileFetcher.file_exists?(@page_html_path)
        if special_layout?
          get_special_layout
        else
          get_standard_layout
        end
      else
        raise Rush::PageMakerError.new(Rush::ERROR_TITLE_PAGE_NOT_FOUND + " #{@page_html_path}", Rush::ERROR_DESC_PAGE_NOT_FOUND)
      end
    end

    def get_special_layout
      special_layout_file_name = @first_line_of_file[/layout:[^\s]+/].split(":")[1]
      @layout_path = File.join @layouts_folder, "#{special_layout_file_name}.html"
      if Rush::FileFetcher.file_exists?(@layout_path)
        Rush::FileFetcher.get_file_contents(@layout_path)
      else
        raise Rush::PageMakerError.new(Rush::ERROR_TITLE_LAYOUT_NOT_FOUND + " #{@layout_path}", Rush::ERROR_DESC_LAYOUT_NOT_FOUND)
      end
    end

    def get_standard_layout
      @layout_path = File.join @layouts_folder, "application.html"
      if Rush::FileFetcher.file_exists?(@layout_path)
        Rush::FileFetcher.get_file_contents(@layout_path)
      else
        raise Rush::PageMakerError.new(Rush::ERROR_TITLE_STANDARD_LAYOUT_NOT_FOUND + " #{@layout_path}", Rush::ERROR_DESC_STANDARD_LAYOUT_NOT_FOUND)
      end
    end

    def special_layout?
      @first_line_of_file = Rush::FileFetcher.first_line_of_file(@page_html_path)
      if @first_line_of_file =~ /layout:[^\s]/
        return true
      else
        return false
      end
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
