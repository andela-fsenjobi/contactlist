require "rails_helper"

describe Api::V1::UsersController do
  let(:user) { create(:user) }
  describe 'GET #show' do
    before(:each) do
      api_authorization_header(user)
      get :show, id: user.id
    end

    it "returns the information about a user on a hash" do
      user_response = json_response[:user]
      expect(user_response[:email]).to eql user.email
    end
  end

  describe 'POST #create' do
    context "when is successfully created" do
      it "renders the json representation for the user record just created" do
        user_attributes = attributes_for :user
        put :create, user_attributes
        user_response = json_response
        expect(user_response[:email]).to eql user_attributes[:email]
      end
    end

    context "when is not created" do
      before(:each) do
        invalid_user_attributes = {
          password: "12345678",
          password_confirmation: "12345678"
        }
        put :create, invalid_user_attributes
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context "when is successfully updated" do
      before(:each) do
        api_authorization_header(user)
        patch :update, id: user.id, email: "newmail@men.com"
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql "newmail@men.com"
      end
    end

    context "when is not edited" do
      before(:each) do
        api_authorization_header user
        patch :update, id: user.id, email: ""
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'DELETE #destroy' do
    context "successfully deletes" do
      before(:each) do
        api_authorization_header user
        delete :destroy, id: user.id
      end

      it "expect user to be deleted" do
        user_response = json_response
        expect(user_response[:message]).to include "deleted"
      end
    end
  end
end
