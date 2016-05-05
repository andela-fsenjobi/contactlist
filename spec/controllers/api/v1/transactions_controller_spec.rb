require "rails_helper"

describe Api::V1::TransactionsController do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }

  describe 'GET #show' do
    context "when user is logged in" do
      before(:each) do
        @transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        get :show, customer_id: customer.id, id: @transaction.id
      end

      it "expect to see transaction details" do
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql @transaction.status
        should respond_with 200
      end
    end

    context "when user is logged out" do
      before(:each) do
        @transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        user.logout
        get :show, customer_id: customer.id, id: @transaction.id
      end

      it "expect to see authentication error" do
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        should respond_with 401
      end
    end
  end

  describe 'GET #index' do
    context "when records are less than 20" do
      before(:each) do
        api_authorization_header(user)
        4.times { create(:transaction, user: user, customer: customer) }
        get :index
      end

      it do
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(4)
        expect(transaction_response[:meta][:current_page]).to eql(1)
        expect(transaction_response[:meta][:total_records]).to eql(4)
        should respond_with 200
      end
    end

    context "when records are more than 20" do
      before(:each) do
        api_authorization_header(user)
        24.times { create(:transaction, user: user, customer: customer) }
        get :index, page: 2
      end

      it do
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(4)
        expect(transaction_response[:meta][:current_page]).to eql(2)
        expect(transaction_response[:meta][:total_records]).to eql(24)
      end
    end

    context "when customer_id is specified" do
      before(:each) do
        api_authorization_header(user)
        5.times { create(:transaction, user: user) }
        3.times { create(:transaction, user: user, customer: customer) }
        get :index, customer_id: customer.id
      end

      it do
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(3)
      end
    end

    context "when customer_id is not specified" do
      before(:each) do
        api_authorization_header(user)
        5.times { create(:transaction, user: user) }
        3.times { create(:transaction, user: user, customer: customer) }
        get :index
      end

      it do
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(8)
      end
    end
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        @transaction_attributes = attributes_for(
          :transaction,
          customer_id: customer.id,
          user: user
        )
        api_authorization_header(user)
        post :create, @transaction_attributes
      end

      it "renders the json attributes of the new record" do
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).
          to eql @transaction_attributes[:status]
        should respond_with 201
      end
    end

    context "when not created" do
      it "renders the json attributes of the new record" do
        api_authorization_header(user)
        post :create, customer_id: customer.id, expiry: nil
        transaction_response = json_response
        expect(transaction_response[:error]).to eql "Transaction not created"
        should respond_with 422
      end
    end
  end

  describe 'PATCH #update' do
    context "when successfully updated" do
      it "renders the json attributes of the new record" do
        transaction = create(:transaction, user: user)
        api_authorization_header(user)
        patch :update,
              customer_id: customer.id,
              id: transaction.id,
              status: "Paid"
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql "Paid"
        should respond_with 201
      end
    end

    context "when not updated" do
      it "renders the json attributes of the new record" do
        transaction = create(:transaction, user: user)
        api_authorization_header(user)
        patch :update,
              customer_id: customer.id,
              id: transaction.id,
              expiry: nil
        transaction_response = json_response
        expect(transaction_response[:error]).to eql "Transaction not created"
        should respond_with 422
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when successfully deleted" do
      it "renders the json attributes of the new record" do
        transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        delete :destroy, id: transaction.id
        transaction_response = json_response
        expect(transaction_response[:message]).to eql "Record deleted"
        should respond_with 204
      end
    end
  end
end
