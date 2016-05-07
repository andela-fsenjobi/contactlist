require "rails_helper"

class Authenticaction
  attr_accessor :response, :request
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authenticaction.new }
  let(:user) { create(:user) }
  subject { authentication }

  describe '#current_user' do
    before(:each) do
      user.login
      payload = {
        email: user.email,
        id: user.id
      }
      request.headers["Authorization"] = JsonWebToken.encode payload
      allow(authentication).to receive(:request).and_return(request)
    end

    it "return the user from the authentication headers" do
      expect(authentication.current_user.email).to eql(user.email)
    end
  end

  describe '#authenticate_with_token' do
    before(:each) do
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).
        and_return({ errors: "Not Authenticated" }.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "renders a an error message" do
      expect(json_response[:errors]).to eql "Not Authenticated"
      is_expected.to respond_with 401
    end
  end

  describe '#user_signed_in?' do
    context "when there is a user on session" do
      before do
        expect(authentication).to receive(:current_user).and_return(user)
      end

      it "returns that the user is signed in" do
        user.login
        is_expected.to be_user_signed_in
      end
    end

    context "when there is no user on session" do
      before do
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { is_expected.to_not be_user_signed_in }
    end
  end
end
