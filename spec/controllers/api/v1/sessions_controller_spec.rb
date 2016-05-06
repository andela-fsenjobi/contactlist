require "rails_helper"

describe Api::V1::SessionsController do
  let(:user) { create(:user) }
  describe 'POST #create' do
    context "when credentials are correct" do
      before(:each) do
        credentials = { email: user.email, password: "1qw23er45t" }
        post :create, credentials
      end

      it "returns the corresponding records" do
        user.reload
        expect(json_response[:email]).to eql user.email
        should respond_with 200
      end
    end

    context "when credentials are incorrect" do
      before(:each) do
        credentials = { email: user.email, password: "qwewqwewqwewq" }
        post :create, credentials
      end

      it "returns the corresponding records" do
        expect(json_response[:error]).to eql "Invalid login credentials"
        should respond_with 422
      end
    end
  end

  describe 'GET #destroy' do
    context "user logged in" do
      before(:each) do
        api_authorization_header(user)
        get :destroy
      end

      it do
        expect(json_response[:message]).to eql "You are logged out"
        should respond_with 401
      end
    end

    context "user not logged in" do
      before(:each) do
        create(:user)
        get :destroy
      end

      it do
        expect(json_response[:errors]).to eql "Not authenticated"
        should respond_with 401
      end
    end

    context "user logged out" do
      before(:each) do
        api_authorization_header(user)
        user.logout
        get :destroy
      end

      it { expect(json_response[:errors]).to eql "Not authenticated" }
    end
  end
end
