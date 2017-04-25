require 'railtie'

# require 'active_support/tagged_logging'

module DetailParser
  class Logger
    def self.setup(app)
      self.application = app
      Lograge::RequestLogSubscriber.attach_to :action_controller
      puts "NOTICE: Gem is ok"
    end
  end
end
