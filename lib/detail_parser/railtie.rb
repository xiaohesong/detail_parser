require 'rails/railtie'
require 'action_view/log_subscriber'
require 'action_controller/log_subscriber'

class DetailParser::Railtie < Rails::Railtie
  env = Rails.env.to_sym || :development

  puts " ====== in Rails railtile"

  config.detail_parser = ActiveSupport::OrderedOptions.new
  config.detail_parser.enabled = false

  # DetailParser::Logger.logger = Rails.application.config.logger || Rails.logger.presence

  initializer 'detail parser logger', after: :load_config_initializers do
    DetailParser.logger = Rails.application.config.logger || Rails.logger.presence
    DetailParser.filter = ActionDispatch::Http::ParameterFilter.new Rails.application.config.filter_parameters
  end

  config.after_initialize do |app|
    puts "这里的app是#{app}"
    DetailParser.setup(app)
  end
end
