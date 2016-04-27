class ApplicationController < ActionController::API
  include ::ActionController::Serialization
  include Authenticable
end
