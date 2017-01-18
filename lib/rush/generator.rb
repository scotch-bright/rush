module Rush

  class Generator

    def initialize project_path
      @project_path = project_path
      @path_to_templates_folder = File.expand_path( "../../templates/starter_app", __FILE__ )
    end

    def make_project
      delete_folder_at_path
      FileUtils.copy_entry @path_to_templates_folder, @project_path
    end

    private

    def delete_folder_at_path
      FileUtils.rm_rf(@project_path)
    end

  end

end
