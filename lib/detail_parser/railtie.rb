require 'rails/railtie'
require 'action_view/log_subscriber'
require 'action_controller/log_subscriber'

class DetailParser::Railtie < Rails::Railtie
  env = Rails.env.to_sym || :development


  config.detail_parser = ActiveSupport::OrderedOptions.new
  config.detail_parser.enabled = false

  initializer 'detail parser logger', after: :load_config_initializers do
    DetailParser.logger = Rails.application.config.logger || Rails.logger.presence
    DetailParser.filter = ActionDispatch::Http::ParameterFilter.new Rails.application.config.filter_parameters
  end

  config.after_initialize do |app|
    DetailParser.setup(app) if app.config.detail_parser.enabled
  end
end
