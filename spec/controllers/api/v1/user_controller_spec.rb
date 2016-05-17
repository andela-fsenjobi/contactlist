require "rails_helper"

describe Api::V1::UsersController do
  let(:user) { create(:user) }

  describe 'GET #show' do
    it "returns the curret user's data" do
      api_authorization_header(user)
      get :show, id: user.id
      user_response = json_response[:user]
      expect(user_response[:email]).to eql user.email
    end
  end

  describe 'POST #create' do
    context "when valid attributes are passed" do
      it "creates and returns new user record" do
        user_attributes = attributes_for :user
        put :create, user_attributes
        user_response = json_response
        expect(user_response[:email]).to eql user_attributes[:email]
      end
    end

    context "when email is not provided" do
      it "returns email errors" do
        invalid_user_attributes = { password: "12345678" }
        put :create, invalid_user_attributes
        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context "when valid email is passed" do
      it "updates and returns the updated user record" do
        api_authorization_header(user)
        patch :update, id: user.id, email: "newmail@men.com"
        user_response = json_response[:user]
        expect(user_response[:email]).to eql "newmail@men.com"
      end
    end

    context "when an invalid email is passed" do
      it "returns email errors" do
        api_authorization_header user
        patch :update, id: user.id, email: ""
        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'DELETE #destroy' do
    context "valid user is passed" do
      it "returns a success message" do
        api_authorization_header user
        delete :destroy, id: user.id
        user_response = json_response
        expect(user_response[:message]).to include "deleted"
      end
    end
  end
end
