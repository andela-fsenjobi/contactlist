require "rails_helper"

describe Api::V1::TransactionsController do
  let(:user) { create(:user) }
  let(:customer) { create(:customer) }

  describe 'GET #show' do
    context "when authentication token is provided" do
      it "returns the transaction details" do
        transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        get :show, customer_id: customer.id, id: transaction.id
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql transaction.status
        is_expected.to respond_with 200
      end
    end

    context "when authentication token is provided and user is logged out" do
      it "returns an error message" do
        transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        user.logout
        get :show, customer_id: customer.id, id: transaction.id
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end

    context "when authentication token is not provided" do
      it "returns an error message" do
        transaction = create(:transaction, user: user, customer: customer)
        get :show, customer_id: customer.id, id: transaction.id
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end
  end

  describe 'GET #index' do
    context "when records are less than 20" do
      it "returns all records on default page" do
        api_authorization_header(user)
        4.times { create(:transaction, user: user, customer: customer) }
        get :index
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(4)
        expect(transaction_response[:meta][:current_page]).to eql(1)
        expect(transaction_response[:meta][:total_records]).to eql(4)
        is_expected.to respond_with 200
      end
    end

    context "when there are 24 records" do
      it "returns the last 4 records on the second page" do
        api_authorization_header(user)
        24.times { create(:transaction, user: user, customer: customer) }
        get :index, page: 2
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(4)
        expect(transaction_response[:meta][:current_page]).to eql(2)
        expect(transaction_response[:meta][:total_records]).to eql(24)
      end
    end

    context "when customer_id is specified" do
      it "returns customer's transactions" do
        api_authorization_header(user)
        2.times { create(:transaction, user: user) }
        transaction = create(:transaction, user: user, customer: customer)
        get :index, customer_id: customer.id
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(1)
        expect(transaction_response[:transactions][0][:id]).
          to eql transaction.id
      end
    end

    context "when customer_id is not specified" do
      it "returns all user's transactions" do
        api_authorization_header(user)
        2.times { create(:transaction, user: user) }
        1.times { create(:transaction, user: user, customer: customer) }
        get :index
        transaction_response = json_response
        expect(transaction_response[:transactions].length).to eql(3)
      end
    end

    context "when authentication token is not provided" do
      it "returns an error message" do
        create(:transaction, user: user, customer: customer)
        get :index
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end
  end

  describe 'POST #create' do
    context "when transaction attributes are valid" do
      it "creates and returns the new transaction" do
        transaction_attributes = attributes_for(
          :transaction,
          customer_id: customer.id,
          user: user
        )
        api_authorization_header(user)
        post :create, transaction_attributes
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).
          to eql transaction_attributes[:status]
        is_expected.to respond_with 201
      end
    end

    context "when expiry is nil" do
      it "returns an error message" do
        api_authorization_header(user)
        post :create, customer_id: customer.id, expiry: nil
        transaction_response = json_response
        expect(transaction_response[:error]).to eql "Transaction not created"
        is_expected.to respond_with 422
      end
    end

    context "when authentication token is not provided" do
      it "returns an error message" do
        post :create, customer_id: customer.id, expiry: nil
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end
  end

  describe 'PATCH #update' do
    context "when valid attributes are supplied" do
      it "updates and returns the updated transaction" do
        transaction = create(:transaction, user: user)
        api_authorization_header(user)
        patch :update,
              customer_id: customer.id,
              id: transaction.id,
              status: "Paid"
        transaction_response = json_response[:transaction]
        expect(transaction_response[:status]).to eql "Paid"
        is_expected.to respond_with 201
      end
    end

    context "when expiry is nil" do
      it "returns an error message" do
        transaction = create(:transaction, user: user)
        api_authorization_header(user)
        patch :update,
              customer_id: customer.id,
              id: transaction.id,
              expiry: nil
        transaction_response = json_response
        expect(transaction_response[:error]).to eql "Transaction not updated"
        is_expected.to respond_with 422
      end
    end

    context "when authentication token is not provided" do
      it "returns an error message" do
        transaction = create(:transaction, user: user)
        patch :update,
              customer_id: customer.id,
              id: transaction.id,
              expiry: nil
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when valid id is passed" do
      it "renders the json attributes of the new record" do
        transaction = create(:transaction, user: user, customer: customer)
        api_authorization_header(user)
        delete :destroy, id: transaction.id
        transaction_response = json_response
        expect(transaction_response[:message]).to eql "Record deleted"
        is_expected.to respond_with 204
      end
    end

    context "when authentication token is not provided" do
      it "returns an error message" do
        transaction = create(:transaction, user: user, customer: customer)
        delete :destroy, id: transaction.id
        transaction_response = json_response
        expect(transaction_response[:errors]).to eql "Not authenticated"
        is_expected.to respond_with 401
      end
    end
  end
end
