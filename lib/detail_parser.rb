require "detail_parser/version"
require "detail_parser/log_subscriber"
require 'detail_parser/configurable'
require 'detail_parser/railtie' if defined?(Rails)
require 'detail_parser/formatters/json'

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections'
require 'active_support/ordered_options'

begin
  require "pry"
rescue LoadError
end

module DetailParser

  class << self
    attr_accessor :logger, :filter, :application
  end

  puts "in detail_parser module -- second"
  # Your code goes here...
  module_function

  def setup(app)
    puts "detail_parser setup, app　is #{app}"
    self.application = app

    attach_to_action_controller
    # set_lograge_log_options
    # support_deprecated_config
    set_formatter
    # set_ignores
    # Logger.setup
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


  def attach_to_action_controller
    DetailParser::LogSubscriber.attach_to :action_controller
  end

  def detail_config
    application.config.detail_parser
  end

end
