class ApplicationController < ActionController::API
  include ::ActionController::Serialization
  include Authenticable

  def no_route_found
    found = { error: "The end point you requested does not exist.",
              debug: "Please check the documentation for existing end points" }
    render json: found, status: 404
  end
end
