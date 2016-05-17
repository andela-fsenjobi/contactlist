require "rails_helper"

class Authenticaction
  attr_accessor :response, :request
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authenticaction.new }
  let(:message) { Messages.new }
  let(:user) { create(:user) }
  subject { authentication }

  describe '#current_user' do
    it "return the user from the authentication headers" do
      user.login
      payload = {
        email: user.email,
        id: user.id
      }
      request.headers["Authorization"] = JsonWebToken.encode payload
      allow(authentication).to receive(:request).and_return(request)
      expect(authentication.current_user.email).to eql(user.email)
    end
  end

  describe '#authenticate_with_token' do
    it "renders a an error message" do
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).
        and_return({ errors: message.auth_error }.to_json)
      allow(authentication).to receive(:response).and_return(response)
      expect(json_response[:errors]).to eql message.auth_error
      is_expected.to respond_with 401
    end
  end

  describe '#user_signed_in?' do
    context "when there is a user on session" do
      it "returns that the user is signed in" do
        expect(authentication).to receive(:current_user).and_return(user)
        user.login
        is_expected.to be_user_signed_in
      end
    end

    context "when there is no user on session" do
      it "should return false for user_signed_in?" do
        allow(authentication).to receive(:current_user).and_return(nil)
        is_expected.to_not be_user_signed_in
      end
    end
  end
end
