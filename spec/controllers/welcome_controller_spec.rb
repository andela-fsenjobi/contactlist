require "rails_helper"

describe WelcomeController do
  describe "#index" do
    it "should be successful" do
      get :index
      should respond_with 200
    end
  end
end
