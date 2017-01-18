require 'thor'

module Rush

  class CLI < Thor
    
    desc "new PROJECT_NAME", "Creates a new Rush project inside the current folder"

    def new (project_name)
      puts "So..you wanna create a project called #{project_name}"
    end

  end

end