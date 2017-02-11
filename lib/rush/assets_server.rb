require 'coffee-script'
require 'sass'

module Rush

  class AssetsServer

    # Method that is required to turn the class into a Rack app
    def call(env)
      request = Rack::Request.new(env)
      path = request.path

      # Removing the starting forward slash that comes with the path
      path = convert_path_to_file_call path

      begin
        output = get_file(path)
        if output == ""
          ['404', {'Content-Type' => 'text/html'}, [get_404_message]]
        else
          ['200', {'Content-Type' => get_mime_type}, [output]]
        end
      rescue Exception => e
        ['500', {'Content-Type' => 'text/html'}, [e.message + " :: " + e.long_error_description]]
      end

    end


    def get_file(file_name, production=nil)
      if file_name.include?(".exclude") && production
        return ""
      end

      output = ""

      if does_file_need_pre_processing file_name
        output = handle_files_that_need_to_be_pre_processed file_name
      else
        if file_name =~ /application\.(js|css)/
          array_of_files = Rush::FileFetcher.array_of_file_paths(folder_path)
          array_of_files.each_with_index do |file_path, i|
            file_name = Rush::FileFetcher.get_file_name_and_extension_from_path(file_path)
            output = output + get_file(file_name, production)
            output = output + "\n" if i < array_of_files.size - 1
          end
        else
          output = get_file_contents(file_name)
        end
      end

      # Minify the file if the minify flag is set to true.
      if production && minify
        output = minify_this(output)
      end

      return output
    end

    private

    def handle_files_that_need_to_be_pre_processed file_name

      if is_file_coffee_script? file_name
        begin
          output = CoffeeScript.compile get_file_contents(file_name)
        rescue
          raise Rush::RushError.new Rush::ERROR_TITLE_MALFORMED_COFFEE_SCRIPT + file_name, Rush::ERROR_DESC_MALFORMED_COFFEE_SCRIPT
        end
      elsif is_file_scss? file_name
        begin
          output = Sass::Engine.new(get_file_contents(file_name), :syntax => :scss).render
        rescue
          raise Rush::RushError.new Rush::ERROR_TITLE_MALFORMED_SCSS_SCRIPT + file_name, Rush::ERROR_DESC_MALFORMED_SCSS_SCRIPT
        end
      end

    end

    def get_file_contents file_name
      file_path = File.join(folder_path, file_name)
      if Rush::FileFetcher.file_exists?(file_path)
        Rush::FileFetcher.get_file_contents file_path
      else
        ""
      end
    end

    def does_file_need_pre_processing file_name
      is_file_coffee_script?(file_name) || is_file_scss?(file_name)
    end

    def is_file_coffee_script? file_name
      file_name.split(".").last == "coffee" ? true : false
    end

    def is_file_scss? file_name
      file_name.split(".").last == "scss" ? true : false
    end

  end

end
