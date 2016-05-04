require "rails_helper"

describe Api::V1::CustomersController do
  describe 'GET #show' do
    context "when user is logged in" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        api_authorization_header(user)
        get :show, id: @customer.id
      end

      it "expect to see customer details" do
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql @customer.name
      end

      it { should respond_with 200 }
    end

    context "when user is logged out" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        api_authorization_header(user)
        user.logout
        get :show, id: @customer.id
      end

      it "expect to see authentication error" do
        customer_response = json_response
        expect(customer_response[:errors]).to eql "Not authenticated"
      end

      it { should respond_with 401 }
    end
  end

  describe 'GET #index' do
    context "when records are less than 20" do
      before(:each) do
        user = create(:user)
        api_authorization_header(user)
        4.times { create(:customer, user: user) }
        get :index
        @customer_response = json_response
      end

      it { expect(@customer_response[:customers].length).to eql(4) }
      it { expect(@customer_response[:meta][:total]).to eql(4) }
      it { expect(@customer_response[:meta][:current]).to eql(1) }
      it { should respond_with 200 }
    end

    context "when records are more than 20" do
      before(:each) do
        user = create(:user)
        api_authorization_header(user)
        21.times { create(:customer, user: user) }
        get :index, page: 2
        @customer_response = json_response
      end

      it { expect(@customer_response[:customers].length).to eql(21) }
      it { expect(@customer_response[:meta][:total]).to eql(21) }
      it { expect(@customer_response[:meta][:current]).to eql(2) }
    end

    context "when searching records" do
      before(:each) do
        user = create(:user)
        api_authorization_header(user)
        create(:customer, user: user, name: "Ikem")
        3.times { create(:customer, user: user) }
        get :index, q: "Ikem"
        @customer_response = json_response
      end

      it { expect(@customer_response[:customers].length).to eql(1) }
      it { expect(@customer_response[:meta][:total]).to eql(1) }
      it { expect(@customer_response[:meta][:current]).to eql(1) }
    end
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        user = create(:user)
        @customer_attributes = attributes_for(:customer, user: user)
        api_authorization_header(user)
        post :create, customer: @customer_attributes
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response[:customer]
        expect(customer_response[:phone]).to eql @customer_attributes[:phone]
      end

      it { should respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        user = create(:user)
        @customer_attributes = attributes_for(:customer, phone: nil, user: user)
        api_authorization_header(user)
        post :create, customer: @customer_attributes
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response
        expect(customer_response[:error]).to eql "Customer not created"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PATCH #update' do
    context "when successfully updated" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        @customer_attr = attributes_for(:customer, name: "Adebee")
        api_authorization_header(user)
        patch :update, id: @customer.id, customer: @customer_attr
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql @customer_attr[:name]
      end

      it { should respond_with 201 }
    end

    context "when not updated" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        @customer_attr = attributes_for(:customer, name: "")
        api_authorization_header(user)
        patch :update, id: @customer.id, customer: @customer_attr
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response
        expect(customer_response[:error]).to eql "Customer not created"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    context "when successfully deleted" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        api_authorization_header(user)
        delete :destroy, id: @customer.id
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response
        expect(customer_response[:message]).to eql "Record deleted"
      end

      it { should respond_with 204 }
    end
  end
end
