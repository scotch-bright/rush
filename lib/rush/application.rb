module Rush

  class Application
    
  	attr_reader :config

  	def initialize(app_path)
  		set_up_config
  	end

  	def rack_app
  		nil
  	end

  	private
  	def set_up_config
  		@config = nil
  	end

  end

end

