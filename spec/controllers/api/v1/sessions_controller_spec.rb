require "rails_helper"

describe Api::V1::SessionsController do
  let(:user) { create(:user) }
  let(:message) { Messages.new }
  describe 'POST #create' do
    context "when email and username are correct" do
      it "returns user email, token and success message" do
        credentials = { email: user.email, password: "1qw23er45t" }
        post :create, credentials
        user.reload
        expect(json_response[:email]).to eql user.email
        expect(json_response[:token]).to be_present
        expect(json_response[:message]).to eq message.logged_in
        is_expected.to respond_with 200
      end
    end

    context "when password is wrong" do
      it "returns invalid credentials error message" do
        credentials = { email: user.email, password: "qwewqwewqwewq" }
        post :create, credentials
        expect(json_response[:error]).to eql message.invalid_credentials
        is_expected.to respond_with 422
      end
    end
  end

  describe 'GET #destroy' do
    context "when authentication token is provided" do
      it "returns user logged out message" do
        api_authorization_header(user)
        get :destroy
        expect(json_response[:message]).to eql message.logged_out
        is_expected.to respond_with 401
      end
    end

    context "when user authentication token not provided" do
      it "returns authentication error message" do
        create(:user)
        get :destroy
        expect(json_response[:errors]).to eql message.auth_error
        is_expected.to respond_with 401
      end
    end

    context "when user is logged out" do
      it "returns authentication error message" do
        api_authorization_header(user)
        user.logout
        get :destroy
        expect(json_response[:errors]).to eql message.auth_error
      end
    end
  end
end
