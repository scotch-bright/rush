require 'uglifier'
require 'coffee-script'

module Rush

  # == User Requirement Catered To
  # Web developers may use JS or coffee-script or both interchangeably. As a web developer, it's irritating to worry about combining files to reduce the number of HTTP requests being made when the page loads.  Also as per best practices, files should be minified. This too, is a pain. To solve all these problems, the JSS server will automatically serve JS files even if you ask for a .coffee file. It will combine all files in the js folder and serve it as one if you ask for a file called "application.js"
  class JSServer

    def initialize(config)
      @js_folder_path = config.js_folder
      @minify = config.minify_js == true ? true : false
    end

    # Gets the JS file asked for. If .coffee file, it will be auto converted to .js file. If the file asked for is "application.js", then it will be a combination of all the files in the js folder in alphabetical order. Coffee files will be auto converted to CSS as required.
    def get_js_file(file_name)
      output = ""

      if is_file_coffee_script?(file_name)
        # Handle coffee script files
        output = CoffeeScript.compile get_js_file_contents(file_name)
      else

        if file_name == "application.js"
          array_of_files = Rush::FileFetcher.array_of_file_paths(@js_folder_path)
          array_of_files.each_with_index do |file_path, i|
            file_name = Rush::FileFetcher.get_file_name_and_extension_from_path(file_path)
            output = output + get_js_file(file_name)
            output = output + "\n" if i < array_of_files.size - 1
          end
        else
          output = get_js_file_contents(file_name)
        end

      end

      # Minify the file if the minify flag is set to true.
      if @minify
        output = Uglifier.new.compile(output)
      end

      return output
    end

    private

    def is_file_coffee_script?(file_name)
      file_name.split(".")[1] == "coffee" ? true : false
    end

    def get_js_file_contents(js_file_name)
      js_file_path = File.join(@js_folder_path, js_file_name)
      if Rush::FileFetcher.file_exists?(js_file_path)
        Rush::FileFetcher.get_file_contents js_file_path
      else
        ""
      end
    end

  end

end

