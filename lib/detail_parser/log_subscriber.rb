require 'json'
require 'action_pack'
require 'active_support/core_ext/class/attribute'
require 'active_support/log_subscriber'

# require 'active_support/tagged_logging'

module DetailParser
  class LogSubscriber < ActiveSupport::LogSubscriber

    START_LOGGER_FLAT = "=========================================================================================".freeze
    END_LOGGER_FLAT =   "=========================================================================================".freeze

    def process_action(event)
      puts "When the log subscriber is used with process_action"
      payload = event.payload
      puts_sth(event, payload)
      request_data = extract_request(event, payload)
      # data = before_format(data, payload)
      # basic_message = DetailParser.formatter.call(data)
      logger.send(DetailParser.log_level, START_LOGGER_FLAT)
      request_log(request_data)
      response_log(extract_response(event, payload)) unless html_format?(payload)
      logger.send(DetailParser.log_level, END_LOGGER_FLAT)
    end

    def request_log(data)
      logger.send(DetailParser.log_level, data)
    end

    def response_log(data)
      logger.send(DetailParser.log_level, data)
    end

    def puts_sth(event, payload)
      puts "event是#{event}" if DetailParser.detail_config.event
      puts "payload是#{payload}" if DetailParser.detail_config.payload
      puts "payload的request id是#{payload[:request_id]}" if DetailParser.detail_config.show_request
      puts "application是#{DetailParser.application}" if DetailParser.detail_config.pust_app
      puts "env的输出是#{payload[:request].uuid}" if DetailParser.detail_config.req
    end

    def logger
      DetailParser.logger.presence || super
    end

    private
    def extract_request(event, payload)
      payload = event.payload
      data = initial_data(payload)
      data.merge!(extract_status(payload))
      data.merge!(extract_runtimes(event, payload))
      # data.merge!(extract_location)
      # data.merge!(extract_unpermitted_params)
      # data.merge!(custom_options(event))
    end

    def extract_response(event, payload)
      "Response is #{payload[:response].body}"
    end

    def initial_data(payload)
      {
        method: payload[:method],
        request_id: payload[:request].uuid,
        path: extract_path(payload),
        format: extract_format(payload),
        Parameters: payload[:params]
      }
    end

    def logged_ip
      Thread.current[:logged_ip]
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
      data[:Views] = payload[:view_runtime].to_f.round(2) if payload.key?(:view_runtime)
      data[:DB] = payload[:db_runtime].to_f.round(2) if payload.key?(:db_runtime)
      data
    end

    def before_format(data, payload)
      DetailParser.before_format(data, payload)
    end

    def get_error_status_code(exception)
      status = ActionDispatch::ExceptionWrapper.rescue_responses[exception]
      Rack::Utils.status_code(status)
    end


    def html_format?(payload)
      payload[:format].to_s == "html"
    end

  end
end
