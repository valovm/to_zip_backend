class ApplicationController < ActionController::API
  include Responses

  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound do
    render not_found_error
  end
end
