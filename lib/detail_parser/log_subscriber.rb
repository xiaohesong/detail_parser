require 'json'
require 'action_pack'
require 'active_support/core_ext/class/attribute'
require 'active_support/log_subscriber'

# require 'active_support/tagged_logging'

module DetailParser
  class LogSubscriber < ActiveSupport::LogSubscriber

    def process_action(event)
      puts "When the log subscriber is used with process_action"
      payload = event.payload
      data = extract_request(event, payload)
      data = before_format(data, payload)
      formatted_message = DetailParser.formatter.call(data)
      logger.send(DetailParser.log_level, formatted_message)
    end

    def logger
      DetailParser.logger.presence || super
    end

    private
    def extract_request(event, payload)
      puts "rails的方法里的event是#{event}, payload是#{payload}"
      payload = event.payload
      data = initial_data(payload)
      data.merge!(extract_status(payload))
      data.merge!(extract_runtimes(event, payload))
      # data.merge!(extract_location)
      # data.merge!(extract_unpermitted_params)
      # data.merge!(custom_options(event))
    end

    def initial_data(payload)
      {
        method: payload[:method],
        path: extract_path(payload),
        format: extract_format(payload),
        controller: payload[:controller],
        action: payload[:action]
      }
    end

    def extract_path(payload)
      path = payload[:path]
      index = path.index('?')
      index ? path[0, index] : path
    end

    def extract_format(payload)
      payload[:format]
    end

    def extract_status(payload)
      if (status = payload[:status])
        { status: status.to_i }
      elsif (error = payload[:exception])
        exception, message = error
        { status: get_error_status_code(exception), error: "#{exception}: #{message}" }
      else
        { status: 0 }
      end
    end

    def extract_runtimes(event, payload)
      data = { duration: event.duration.to_f.round(2) }
      data[:view] = payload[:view_runtime].to_f.round(2) if payload.key?(:view_runtime)
      data[:db] = payload[:db_runtime].to_f.round(2) if payload.key?(:db_runtime)
      data
    end

    def before_format(data, payload)
      DetailParser.before_format(data, payload)
    end

  end
end
