require 'rails/railtie'
require 'action_view/log_subscriber'
require 'action_controller/log_subscriber'

class DetailParser::Railtile < Rails::Railtie
  env = Rails.env.to_sym || :development

  # DetailParser::Logger.logger = Rails.application.config.logger || Rails.logger.presence

  initializer 'detail parser logger', after: :load_config_initializers do
    DetailParser::Logger.logger = Rails.application.config.logger || Rails.logger.presence
    DetailParser::Logger.filter = ActionDispatch::Http::ParameterFilter.new Rails.application.config.filter_parameters
  end

  config.after_initialize do |app|
    DetailParser.setup(app)
  end
end
