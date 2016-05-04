class WelcomeController < ApplicationController
  respond_to :html
  def index
    render file: "public/index.html"
  end
end
