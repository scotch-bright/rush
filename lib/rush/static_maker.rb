require 'nokogiri'

module Rush

  class StaticMaker

    def initialize folder_path
      @folder_path = folder_path
      @output_folder_path = get_output_folder_path
      make_dir_if_it_does_not_exist @output_folder_path
      @app = Rush::Application.new folder_path
    end

    def get_output_folder_path
      folder_name = File.basename(@folder_path)
      output_folder_name = folder_name + "_static"
      # go one level up
      File.join File.expand_path("..", @folder_path), output_folder_name
    end

    def make_project
      handle_errors_that_prevent_starting
      make_css_folder
      make_css_files
      make_js_folder
      make_js_files
      make_html_files
      copy_static_files_folders
    end

    private
    def make_html_files
      source_html_file_path = @app.config.pages_folder
      array_of_html_file_names = Rush::FileFetcher.array_of_file_paths(source_html_file_path).map { |e| Rush::FileFetcher.get_file_name_and_extension_from_path(e) }
      array_of_html_file_names.each do |file_name|
        if file_name == "index.html"
          final_path = File.join @output_folder_path, file_name
          create_or_overwrite_file(final_path, get_html_content("index"))
        else
          file_name_without_extension = Rush::FileFetcher.get_file_name_from_path(file_name)
          final_folder_path = File.join @output_folder_path, file_name_without_extension
          make_dir_if_it_does_not_exist final_folder_path
          final_file_path = File.join(final_folder_path, "index.html")
          create_or_overwrite_file(final_file_path, get_html_content(file_name_without_extension))
        end
      end
    end

    def get_html_content path
      content = @app.page_maker.get_page(path)[:html]
      content = chnage_scss_extenstions_to_css_extenstions_in_html content
      content = chnage_coffee_extenstions_to_js_extenstions_in_html content
      if path != "index"
        #Making all the refrences in the inner files go one level up
        content = content.gsub(/('|")(static_files|js|css|images|fonts)\//, '\1../\2/')
      else
        content
      end
    end

    def chnage_scss_extenstions_to_css_extenstions_in_html the_html
      html_doc = Nokogiri::HTML(the_html)

      html_doc.css("link").each do |ele|
        unless ele['href'].nil?
          the_value = ele['href']
          if the_value.start_with?("css/") && the_value.end_with?(".scss")
            ele['href'] = ele['href'].gsub(/\.scss$/, ".css")
          end
        end
      end
      html_doc.to_html
    end

    def chnage_coffee_extenstions_to_js_extenstions_in_html the_html
      html_doc = Nokogiri::HTML(the_html)

      html_doc.css("script").each do |ele|
        unless ele['src'].nil?
          the_value = ele['src']
          if the_value.start_with?("js/") && the_value.end_with?(".coffee")
            ele['src'] = ele['src'].gsub(/\.coffee$/, ".js")
          end
        end
      end

      html_doc.to_html
    end

    def make_dir_if_it_does_not_exist dir_path
      unless Rush::FileFetcher.directory_exists?(dir_path)
        Dir.mkdir dir_path
      end
    end

    def make_js_files
      source_js_folder_path = @app.config.js_folder
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
      source_css_folder_path = @app.config.css_folder
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

    def copy_static_files_folders
    	copy_folder File.join(@folder_path, "images"), File.join(@output_folder_path, "images")
    	copy_folder File.join(@folder_path, "static_files"), File.join(@output_folder_path, "static_files")
    end

    def copy_folder source_path, destination_path
    	if Rush::FileFetcher.directory_exists? source_path
    		FileUtils.copy_entry source_path, destination_path
    	end
    end

    def create_or_overwrite_file file_path, contents
      File.open(file_path, "w") { |f| f.write(contents) }
    end

    def handle_errors_that_prevent_starting
      raise Rush::RushMakeError.new Rush::ERROR_RUSH_MAKE_NO_FOLDER_FOUND unless Rush::FileFetcher.directory_exists?(@folder_path)
      raise Rush::RushMakeError.new Rush::ERROR_RUSH_MAKE_NO_PAGES_FOLDER_FOUND unless Rush::FileFetcher.directory_exists?(@app.config.pages_folder)
      raise Rush::RushMakeError.new Rush::ERROR_RUSH_MAKE_NO_PAGES_FOLDER_FOUND unless Rush::FileFetcher.array_of_file_paths(@app.config.pages_folder).select{ |e| e.include? ".html"  }.length > 0
    end

    def make_css_folder
      @css_folder_path = File.join @output_folder_path, "css"
      make_dir_if_it_does_not_exist @css_folder_path
    end

    def make_js_folder
      @js_folder_path = File.join @output_folder_path, "js"
      make_dir_if_it_does_not_exist @js_folder_path
    end

    def log(title, msg)
      puts "\n\n\n" + "=" * 10 + title + "=" * 10 + "\n" + msg + "=" * 20 + "\n\n\n"
    end

  end

  class RushMakeError < StandardError
  end

end
