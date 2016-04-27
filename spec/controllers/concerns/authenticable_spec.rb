require "rails_helper"

class Authenticaction
  attr_accessor :response, :request
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authenticaction.new }
  subject { authentication }

  describe '#current_user' do
    before(:each) do
      @user = create(:user)
      payload = {
        email: @user.email,
        id: @user.id
      }
      request.headers["Authorization"] = JsonWebToken.encode payload
      allow(authentication).to receive(:request).and_return(request)
    end

    it "return the user from the authentication headers" do
      expect(authentication.current_user.email).to eql(@user.email)
    end
  end

  describe '#authenticate_with_token' do
    before(:each) do
      @user = create(:user)
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).
        and_return({ errors: "Not Authenticated" }.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "renders a an error message" do
      expect(json_response[:errors]).to eql "Not Authenticated"
    end

    it { should respond_with 401 }
  end

  describe '#user_signed_in?' do
    context "when there is a user on session" do
      before do
        @user = create(:user)
        expect(authentication).to receive(:current_user).and_return(@user)
      end

      it { should be_user_signed_in }
    end

    context "when there is no user on session" do
      before do
        @user = create(:user)
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end
