require "rails_helper"

RSpec.describe ApplicationController do
  let(:message) { Messages.new }
  describe "#no_route_found" do
    context "when get request is sent to invalid endpoint" do
      it "returns invalid endpoint error message" do
        get "/routes/not/found"
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq message.invalid_endpoint
        expect(json_response["debug"]).to eq message.debug
      end
    end

    context "when post request is sent to invalid endpoint" do
      it "returns invalid endpoint error message" do
        post "/routes/not/found"
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq message.invalid_endpoint
        expect(json_response["debug"]).to eq message.debug
      end
    end

    context "when delete request is sent to invalid endpoint" do
      it "returns invalid endpoint error message" do
        put "/routes/not/found"
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq message.invalid_endpoint
        expect(json_response["debug"]).to eq message.debug
      end
    end

    context "when delete request is sent to invalid endpoint" do
      it "returns invalid endpoint error message" do
        delete "/routes/not/found"
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq message.invalid_endpoint
        expect(json_response["debug"]).to eq message.debug
      end
    end
  end
end
