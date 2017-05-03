Rails.application.configure do
  config.detail_parser.enabled = true
  config.detail_parser.current_user = true
end


ActionController::Instrumentation.class_eval do
  def process_action(*args)
    raw_payload = {
      controller: self.class.name,
      action:     self.action_name,
      params:     request.filtered_parameters,
      format:     request.format.try(:ref),
      method:     request.method,
      path:       (request.fullpath rescue "unknown"),
      request:    request,
      response:   response,
      session:    session
    }

    ActiveSupport::Notifications.instrument("start_processing.action_controller", raw_payload.dup)

    ActiveSupport::Notifications.instrument("process_action.action_controller", raw_payload) do |payload|
      result = super
      payload[:status] = response.status
      # payload[:current_user] = "User Id #{current_user.id} | User name #{current_user.name}"
      append_info_to_payload(payload)
      result
    end
  end
end
