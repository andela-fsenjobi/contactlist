require "rails_helper"

RSpec.describe ApplicationController do
  describe "get /bucketlists/:id/items/:id" do
    context "when url is not valid" do
      it "returns an error message" do
        get "/routes/not/found"
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).
          to eq "The end point you requested does not exist."
      end
    end
  end
end
