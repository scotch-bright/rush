require 'thor'

module Rush

  class CLI < Thor
    
    desc "new PROJECT_NAME", "Creates a new Rush project inside the current folder"
    def new (project_name)
    	puts "Awesome! New Rush project coming up in a giffy!"
      	Rush::Generator.new(File.join Dir.pwd, project_name).make_project
      	puts "Project ready! cd into the '#{project_name}' folder and run 'rush start' to start up the server!"
    end

    desc "start", "Tries to use the current folder as a Rush application and start the server"
    def start
    	puts "Starting up the Rush sever. ('Ctrl+C' to exit) If this folder is a proper Rush application everything should go well :-)"
    	app = Rush::Application.new Dir.pwd
    	Rack::Handler::WEBrick.run app
    end

  end

end