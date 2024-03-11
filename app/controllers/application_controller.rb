class ApplicationController < ActionController::Base
  rescue_from Exception do |exception|
    render status: 500, json: I18n.translate('generic.errors.unhandled_server_error')
  end
  rescue_from ActionController::ParameterMissing do |exception|
  	 render status: 400, json: I18n.translate('generic.errors.missing_field', field_name: exception.param.try(:to_s))
  end
end
