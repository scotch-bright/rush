module Rush

  class StaticMaker

    def initialize folder_path
      @folder_path = folder_path
      @output_folder_path = get_output_folder_path
      make_dir_if_it_does_not_exist @output_folder_path
      @app = Rush::Application.new folder_path
    end

    def make_project
      handle_errors_that_prevent_starting
      make_css_folder
      make_css_files
      make_js_folder
      make_js_files
    end

    private
    def make_dir_if_it_does_not_exist dir_path
      unless Rush::FileFetcher.directory_exists?(dir_path)
        Dir.mkdir dir_path
      end
    end

    def make_js_files
      source_js_folder_path = File.join @folder_path, "js"
      if Rush::FileFetcher.directory_exists? source_js_folder_path
        array_of_js_file_names = Rush::FileFetcher.array_of_file_paths(source_js_folder_path).map { |e| Rush::FileFetcher.get_file_name_and_extension_from_path(e) }
        array_of_js_file_names.each do |file_name|
          final_file_name = Rush::FileFetcher.get_file_name_from_path(file_name) + ".js"
          final_file_path = File.join @js_folder_path, final_file_name
          create_or_overwrite_file(final_file_path, @app.js_server.get_js_file(file_name))
        end
        create_or_overwrite_file(File.join(@js_folder_path, "application.js"), @app.js_server.get_js_file("application.js"))
      end
    end

    def make_css_files
      source_css_folder_path = File.join @folder_path, "css"
      if Rush::FileFetcher.directory_exists? source_css_folder_path
        array_of_css_file_names = Rush::FileFetcher.array_of_file_paths(source_css_folder_path).map { |e| Rush::FileFetcher.get_file_name_and_extension_from_path(e) }
        array_of_css_file_names.each do |file_name|
          final_file_name = Rush::FileFetcher.get_file_name_from_path(file_name) + ".css"
          final_file_path = File.join @css_folder_path, final_file_name
          create_or_overwrite_file(final_file_path, @app.css_server.get_css_file(file_name))
        end
        create_or_overwrite_file(File.join(@css_folder_path, "application.css"), @app.css_server.get_css_file("application.css"))
      end
    end

    def create_or_overwrite_file file_path, contents
		File.open(file_path, "w") { |f| f.write(contents) }
    end

    def handle_errors_that_prevent_starting
      raise Rush::RushMakeError.new Rush::ERROR_RUSH_MAKE_NO_FOLDER_FOUND unless Rush::FileFetcher.directory_exists?(@folder_path)
      raise Rush::RushMakeError.new Rush::ERROR_RUSH_MAKE_NO_PAGES_FOLDER_FOUND unless Rush::FileFetcher.directory_exists?(File.join @folder_path, "pages")
      raise Rush::RushMakeError.new Rush::ERROR_RUSH_MAKE_NO_PAGES_FOLDER_FOUND unless Rush::FileFetcher.array_of_file_paths(File.join @folder_path, "pages").select{ |e| e.include? ".html"  }.length > 0
    end

    def make_css_folder
      @css_folder_path = File.join @output_folder_path, "css"
      make_dir_if_it_does_not_exist @css_folder_path
    end

    def make_js_folder
      @js_folder_path = File.join @output_folder_path, "js"
      make_dir_if_it_does_not_exist @js_folder_path
    end

    def get_output_folder_path
      folder_name = File.basename(@folder_path)
      output_folder_name = folder_name + "_static"
      # go one level up
      File.join File.expand_path("..", @folder_path), output_folder_name
    end

    def log(title, msg)
      puts "\n\n\n" + "=" * 10 + title + "=" * 10 + "\n" + msg + "=" * 20 + "\n\n\n"
    end

  end

  class RushMakeError < StandardError
  end

end
