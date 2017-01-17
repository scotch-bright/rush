module Rush

  class Generator

    def initialize project_path
      @project_path = project_path
      @path_to_templates_folder = File.expand_path( "../../templates", __FILE__ )
    end

    def make_project
      delete_folder_at_path
      make_folder_at_path @project_path
      make_project_folders
      make_project_files
    end

    private

    def make_project_files
    end

    def make_file_from_template tamplate_and_file_path_hash
      File.open(tamplate_and_file_path_hash[:path], "w+") do |file|
        file.write get_processed_file_contents_from_template[:template]
      end
    end

    def get_processed_file_contents_from_template template
      template = Rush::FileFetcher.get_file_contents( File.join( @path_to_templates_folder, template ) )
      ERB.new(template).result(binding)
    end

    def make_project_folders
      make_folders_inside_project "pages", "headers", "partials", "layouts", "data", "css", "js", "images", "static_files" 
    end

    def make_folders_inside_project array_of_folder_names
      array_of_folder_names.each do |folder_name|
        Dir.mkdir File.join(@project_path, folder_name)
      end
    end

    def delete_folder_at_path
      FileUtils.rm_rf(@project_path)
    end

    def make_folder_at_path(path)
      Dir.mkdir path
    end

  end

end
