require "rails_helper"

RSpec.describe ApplicationController do
  let(:message) { Messages.new }
  describe "get /bucketlists/:id/items/:id" do
    context "when url is not valid" do
      it "returns invalid endpoint error message" do
        get "/routes/not/found"
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq message.invalid_endpoint
        expect(json_response["debug"]).to eq message.debug
      end
    end
  end
end
