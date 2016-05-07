require "rails_helper"

describe Api::V1::CustomersController do
  let(:user) { create(:user) }
  describe 'GET #show' do
    context "when user is logged in" do
      before(:each) do
        @customer = create(:customer, user: user)
        api_authorization_header(user)
        get :show, id: @customer.id
      end

      it "expect to see customer details" do
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql @customer.name
        is_expected.to respond_with 200
      end
    end

    context "when user is logged out" do
      before(:each) do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        user.logout
        get :show, id: customer.id
      end

      it "expect to see authentication error" do
        customer_response = json_response
        expect(customer_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end
  end

  describe 'GET #index' do
    context "when records are less than 20" do
      before(:each) do
        api_authorization_header(user)
        4.times { create(:customer, user: user) }
        get :index
      end

      it "returns all records by default" do
        customer_response = json_response
        expect(customer_response[:customers].length).to eql(4)
        expect(customer_response[:meta][:total_records]).to eql(4)
        expect(customer_response[:meta][:current_page]).to eql(1)
        is_expected.to respond_with 200
      end
    end

    context "when records are more than 20" do
      before(:each) do
        api_authorization_header(user)
        21.times { create(:customer, user: user) }
        get :index, page: 2
      end

      it "returns one record on the second page" do
        customer_response = json_response
        expect(customer_response[:customers].length).to eql(1)
        expect(customer_response[:meta][:total_records]).to eql(21)
        expect(customer_response[:meta][:current_page]).to eql(2)
      end
    end

    context "when searching records" do
      before(:each) do
        api_authorization_header(user)
        create(:customer, user: user, name: "Ikem")
        3.times { create(:customer, user: user) }
        get :index, q: "Ikem"
      end

      it "returns item that matches the search query" do
        customer_response = json_response
        expect(customer_response[:customers].length).to eql(1)
        expect(customer_response[:meta][:total_records]).to eql(1)
        expect(customer_response[:meta][:current_page]).to eql(1)
      end
    end
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        @customer_attributes = attributes_for(:customer, user: user)
        api_authorization_header(user)
        post :create, @customer_attributes
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response[:customer]
        expect(customer_response[:phone]).to eql @customer_attributes[:phone]
        is_expected.to respond_with 201
      end
    end

    context "when not created" do
      before(:each) do
        customer_attributes = attributes_for(:customer, phone: nil, user: user)
        api_authorization_header(user)
        post :create, customer: customer_attributes
      end

      it "returns a failure message" do
        customer_response = json_response
        expect(customer_response[:error]).to eql "Customer not created"
        is_expected.to respond_with 422
      end
    end
  end

  describe 'PATCH #update' do
    context "when successfully updated" do
      before(:each) do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        patch :update, id: customer.id, name: "Adebee"
      end

      it "renders the json attributes of the updated record" do
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql "Adebee"
        is_expected.to respond_with 201
      end
    end

    context "when not updated" do
      before(:each) do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        patch :update, id: customer.id, name: ""
      end

      it "returns that customer was not updated" do
        customer_response = json_response
        expect(customer_response[:error]).to eql "Customer not updated"
        is_expected.to respond_with 422
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when successfully deleted" do
      before(:each) do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        delete :destroy, id: customer.id
      end

      it "gives success message" do
        customer_response = json_response
        expect(customer_response[:message]).to eql "Record deleted"
        is_expected.to respond_with 204
      end
    end
  end
end
