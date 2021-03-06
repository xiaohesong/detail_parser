require "detail_parser/version"
require "detail_parser/log_subscriber"
require 'detail_parser/configurable'
require 'detail_parser/railtie' if defined?(Rails)
require 'detail_parser/formatters/json'

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections'
require 'active_support/ordered_options'

module DetailParser

  class << self
    attr_accessor :logger, :filter, :application
  end

  # Your code goes here...
  module_function

  def setup(app)
    self.application = app
    keep_original_log

    attach_to_action_controller
    set_formatter
  end

  mattr_accessor :log_level
  self.log_level = :info

  mattr_writer :before_format
  self.before_format = nil

  def before_format(data, payload)
    result = nil
    result = @@before_format.call(data, payload) if @@before_format
    result || data
  end

  mattr_accessor :formatter
  def set_formatter
    DetailParser.formatter = detail_config.formatter || DetailParser::Formatters::Json.new
  end

  def keep_original_log
    return if detail_config.keep_original_log
    remove_existing_log_subscriptions
  end

  # http://guides.rubyonrails.org/active_support_instrumentation.html
  def remove_existing_log_subscriptions
    ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
      case subscriber
      when ActionView::LogSubscriber
        unsubscribe(:action_view, subscriber) if detail_config.disable_action_view
      when ActionController::LogSubscriber
        unsubscribe(:action_controller, subscriber) if detail_config.disable_action_controller
      when ActiveRecord::LogSubscriber
        unsubscribe(:active_record, subscriber) if detail_config.disable_active_record
      end
    end
  end
  private_class_method :remove_existing_log_subscriptions

  def unsubscribe(component, subscriber)
    events = subscriber.public_methods(false).reject { |method| method.to_s == 'call' }
    events.each do |event|
      ActiveSupport::Notifications.notifier.listeners_for("#{event}.#{component}").each do |listener|
        if listener.instance_variable_get('@delegate') == subscriber
          ActiveSupport::Notifications.unsubscribe listener
        end
      end
    end
  end

  def attach_to_action_controller
    DetailParser::LogSubscriber.attach_to :action_controller
  end

  def detail_config
    application.config.detail_parser
  end

end
