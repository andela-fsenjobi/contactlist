require "rails_helper"

describe Api::V1::CustomersController do
  let(:user) { create(:user) }
  let(:message) { Messages.new }
  describe 'GET #show' do
    context "when authentication token is provided" do
      it "should return customer details" do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        get :show, id: customer.id
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql customer.name
        is_expected.to respond_with 200
      end
    end

    context "when authentication token is not provided" do
      it "returns authentication error message" do
        customer = create(:customer, user: user)
        get :show, id: customer.id
        customer_response = json_response
        expect(customer_response[:errors]).to eql message.auth_error
        is_expected.to respond_with 401
      end
    end
  end

  describe 'GET #index' do
    context "when records are less than 20" do
      it "return all records by default" do
        api_authorization_header(user)
        4.times { create(:customer, user: user) }
        get :index
        customer_response = json_response
        expect(customer_response[:customers].length).to eql(4)
        expect(customer_response[:meta][:total_records]).to eql(4)
        expect(customer_response[:meta][:current_page]).to eql(1)
        is_expected.to respond_with 200
      end
    end

    context "when there are 21 records" do
      it "returns 1 record on the second page" do
        api_authorization_header(user)
        21.times { create(:customer, user: user) }
        get :index, page: 2
        customer_response = json_response
        expect(customer_response[:customers].length).to eql(1)
        expect(customer_response[:meta][:total_records]).to eql(21)
        expect(customer_response[:meta][:current_page]).to eql(2)
      end
    end

    context "when search query is supplied" do
      it "return items that matches the search query" do
        api_authorization_header(user)
        create(:customer, user: user, name: "Ikem")
        3.times { create(:customer, user: user) }
        get :index, q: "Ikem"
        customer_response = json_response
        expect(customer_response[:customers].length).to eql(1)
        expect(customer_response[:meta][:total_records]).to eql(1)
        expect(customer_response[:meta][:current_page]).to eql(1)
      end
    end

    context "when authentication token is not provided" do
      it "returns authentication error message" do
        get :index
        customer_response = json_response
        expect(customer_response[:errors]).to eql message.auth_error
      end
    end
  end

  describe 'POST #create' do
    context "when all customer attributes are supplied" do
      it "creates and returns the new record" do
        customer_attributes = attributes_for(:customer, user: user)
        api_authorization_header(user)
        post :create, customer_attributes
        customer_response = json_response[:customer]
        expect(customer_response[:phone]).to eql customer_attributes[:phone]
        is_expected.to respond_with 201
      end
    end

    context "when phone attribute is nil" do
      it "returns create error message" do
        customer_attributes = attributes_for(:customer, phone: nil, user: user)
        api_authorization_header(user)
        post :create, customer: customer_attributes
        customer_response = json_response
        expect(customer_response[:error]).
          to eql message.create_error("customer")
        is_expected.to respond_with 422
      end
    end

    context "when authentication token is not provided" do
      it "returns authentication error message" do
        post :create, name: "Name", phone: "08012939248"
        customer_response = json_response
        expect(customer_response[:errors]).to eql message.auth_error
        is_expected.to respond_with 401
      end
    end
  end

  describe 'PATCH #update' do
    context "when valid attributes are supplied" do
      it "updates and returns the updated customer" do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        patch :update, id: customer.id, name: "Adebee"
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql "Adebee"
        is_expected.to respond_with 201
      end
    end

    context "when customer name is blank" do
      it "returns update error message" do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        patch :update, id: customer.id, name: ""
        customer_response = json_response
        expect(customer_response[:error]).
          to eql message.update_error("customer")
        is_expected.to respond_with 422
      end
    end

    context "when customer phone is blank" do
      it "returns update error message" do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        patch :update, id: customer.id, phone: ""
        customer_response = json_response
        expect(customer_response[:error]).
          to eql message.update_error("customer")
        is_expected.to respond_with 422
      end
    end

    context "when authentication token is not provided" do
      it "returns authentication error message" do
        customer = create(:customer, user: user)
        patch :update, id: customer.id, phone: ""
        customer_response = json_response
        expect(customer_response[:errors]).to eql message.auth_error
        is_expected.to respond_with 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when valid customer id is supplied" do
      it "returns a success message" do
        customer = create(:customer, user: user)
        api_authorization_header(user)
        delete :destroy, id: customer.id
        customer_response = json_response
        expect(customer_response[:message]).to eql message.delete_message
        is_expected.to respond_with 200
      end
    end
  end
end
