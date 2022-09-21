module Responses
  extend ActiveSupport::Concern

  def json_api_errors(errors, status = 400)
    {
      json: { errors: errors.map { |error| format_error(error, status) } },
      status: status
    }
  end

  def unauthorized_error
    {
      json: { errors: format_error(:unauthorized_error, :unauthorized_error) },
      status: :unauthorized
    }
  end

  def not_found_error
    {
      json: { errors: [{ code: 404, title: 'Not found' }] },
      status: :not_found
    }
  end

  private

  def format_error(error, status)
    case error
    when String
      {
        status: status,
        code: error,
        title: error
      }
    end
  end
end
