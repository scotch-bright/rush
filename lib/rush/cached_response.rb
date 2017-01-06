module Rush

  # This is a file based cache store implementaion. Basically it creates a "temp" folder in the application root. The keys used will be file names like "key.txt" and the value will be the contents of the file. This will be used to speed up processing in production mode. Once the text/html is gathered from the layouts, views, partials etc. the resulting content can be stored into a cached file which can be used on subsequent requests of that path. Thus resulting in faster page loads.
  class CachedResponse

    def initialize(config)
      @application_root = config.application_folder
      @temp_folder_path = File.join(@application_root, "temp")
    end

    # Gets the contents of the key as stored in the file "key.txt" in the temp folder of the application.
    def get_data_by_key(key)
      expected_file_path = File.join(@temp_folder_path, "#{key}.txt")
      if FileFetcher::file_exists?(expected_file_path)
        FileFetcher::get_file_contents(expected_file_path)
      else
        nil
      end
    end

    # Saves the data contents by the key specified and takes the second argument and uses that as the contents of what needs to be saved.
    def set_data_by_key(key, value)
      if FileFetcher::directory_exists?(@temp_folder_path) == false
        create_temp_directory
      end

      temp_file_path = File.join(@temp_folder_path, "#{key}.txt")
      File.open(temp_file_path, "w+") do |file|
        file.write(value)
      end
    end

    private
    def create_temp_directory
      Dir.mkdir File.join(@application_root, "temp")
    end

  end

end
