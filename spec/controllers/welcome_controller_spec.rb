require "rails_helper"

describe WelcomeController do
  describe "#index" do
    it "is_expected.to be successful" do
      get :index
      is_expected.to respond_with 200
      expect(response.body).to include "Authentication"
    end
  end
end
