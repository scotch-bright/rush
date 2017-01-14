module Rush

  # == Internal Rush Helper Object
  # A rush project is going to be made up of many different files. So, we will be using this class to assemble different parts of the code base as and when required.
  class FileFetcher

    # Returns an array of all the files in a folder path specified. The files will be ordered in ascending order of file name.
    def self.array_of_file_paths(folder_path)
      Dir["#{folder_path}/*"]
    end

    # Gets the contents of the file as a string object. Has to be passed a string representing a path of the file.
    def self.get_file_contents(file_path)
      File.read(file_path)
    end

    # Gets the file name without the extension from a given path
    def self.get_file_name_from_path(file_path)
      File.basename(file_path).split(".")[0]
    end

    # Checks if a folder exists
    def self.directory_exists?(folder_path)
      File.directory?(folder_path)
    end

    # Check if the file exists
    def self.file_exists?(file_path)
      File.file?(file_path)
    end

    # Gets the file name and extension from the full file path. Eg: /user/html/html.erb will give html.erb
    def self.get_file_name_and_extension_from_path(file_path)
      File.basename(file_path)
    end

    # Returns the first line of the file in string form
    def self.first_line_of_file(file_path)
      File.open(file_path) {|f| f.readline}
    end

  end

end
