require "rails_helper"

describe Api::V1::TransactionsController do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }

  describe 'GET #show' do
    context "when user is logged in" do
      before(:each) do
        @transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        get :show, id: @transaction.id
      end

      it "expect to see transaction details" do
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql @transaction.status
      end

      it { should respond_with 200 }
    end

    context "when user is logged out" do
      before(:each) do
        @transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        user.logout
        get :show, id: @transaction.id
      end

      it "expect to see authentication error" do
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
      end

      it { should respond_with 401 }
    end
  end

  describe 'GET #index' do
    before(:each) do
      api_authorization_header(user)
      4.times { create(:transaction, user: user, customer: customer) }
      get :index
    end

    it do
      transaction_response = json_response
      expect(transaction_response[:transactions].length).to eql(4)
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        @transaction_attributes = attributes_for(:transaction, user: user)
        api_authorization_header(user)
        post :create, customer_id: customer.id, transaction: @transaction_attributes
      end

      it "renders the json attributes of the new record" do
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql @transaction_attributes[:status]
      end

      it { should respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        @transaction_attributes = attributes_for(:transaction, expiry: nil)
        api_authorization_header(user)
        post :create, customer_id: customer.id, transaction: @transaction_attributes
      end

      it "renders the json attributes of the new record" do
        transaction_response = json_response
        expect(transaction_response[:error]).to eql "Transaction not created"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PATCH #update' do
    context "when successfully updated" do
      before(:each) do
        @transaction = create(:transaction, user: user)
        @transaction_attr = attributes_for(:transaction, status: "Paid")
        api_authorization_header(user)
        patch :update, customer_id: customer.id, id: @transaction.id, transaction: @transaction_attr
      end

      it "renders the json attributes of the new record" do
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql @transaction_attr[:status]
      end

      it { should respond_with 201 }
    end

    context "when not updated" do
      before(:each) do
        @transaction = create(:transaction, user: user)
        @transaction_attr = attributes_for(:transaction, expiry: nil)
        api_authorization_header(user)
        patch :update, customer_id: customer.id, id: @transaction.id, transaction: @transaction_attr
      end

      it "renders the json attributes of the new record" do
        transaction_response = json_response
        expect(transaction_response[:error]).to eql "Transaction not created"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    context "when successfully deleted" do
      before(:each) do
        @transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        delete :destroy, id: @transaction.id
      end

      it "renders the json attributes of the new record" do
        transaction_response = json_response
        expect(transaction_response[:message]).to eql "Record deleted"
      end

      it { should respond_with 204 }
    end
  end
end
