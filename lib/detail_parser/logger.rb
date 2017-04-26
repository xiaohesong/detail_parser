require 'active_support/core_ext/class/attribute'
require 'active_support/log_subscriber'

# require 'active_support/tagged_logging'

module DetailParser
  class Logger < ActiveSupport::LogSubscriber

    def process_action(event)
      payload = event.payload
      data = extract_request(event, payload)
      # data = before_format(data, payload)
      # formatted_message = Lograge.formatter.call(data)
      # logger.send(Lograge.log_level, formatted_message)
    end

    def self.setup(app)
      self.application = app
      # Lograge::RequestLogSubscriber.attach_to :action_controller
      puts "NOTICE: Gem is ok"
    end

    private
    def extract_request(event, payload)
      payload = event.payload
      data = initial_data(payload)
      data.merge!(extract_status(payload))
      data.merge!(extract_runtimes(event, payload))
      data.merge!(extract_location)
      data.merge!(extract_unpermitted_params)
      data.merge!(custom_options(event))
    end

  end
end
