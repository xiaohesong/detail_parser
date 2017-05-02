require "detail_parser/version"
require "detail_parser/logger"
require 'detail_parser/configurable'
require 'detail_parser/railtie' if defined?(Rails)

begin
  require "pry"
rescue LoadError
end

module DetailParser

  puts "in detail_parser module -- second"
  # Your code goes here...
  module_function
  def setup(app)
    puts "detail_parser setup"
    self.application = app

    # attach_to_action_controller
    # set_lograge_log_options
    # support_deprecated_config
    # set_formatter
    # set_ignores
    # Logger.setup
  end


  mattr_writer :before_format
  self.before_format = nil

  def before_format(data, payload)
    result = nil
    result = @@before_format.call(data, payload) if @@before_format
    result || data
  end

  mattr_accessor :formatter

end
