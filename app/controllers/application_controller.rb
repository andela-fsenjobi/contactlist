require "messages"

class ApplicationController < ActionController::API
  include ::ActionController::Serialization
  include Authenticable

  def no_route_found
    found = { error: message.invalid_endpoint,
              debug: message.debug }
    render json: found, status: 404
  end

  def message
    @message ||= Messages.new
  end

  def preflight
    head 200
  end
end
