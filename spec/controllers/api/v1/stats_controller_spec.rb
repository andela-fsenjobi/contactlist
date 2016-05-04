require "rails_helper"

describe Api::V1::StatsController do
  let(:user) { create(:user) }

  describe 'GET #total' do
    before(:each) do
      create(:customer, user: user)
      customer = create(:customer, user: user)
      3.times do
        create(
          :transaction,
          user: user,
          customer: customer,
          created_at: Time.now - 30 * 24 * 60 * 60,
          expiry: Time.now - 30 * 24 * 60 * 60
        )
      end

      3.times do
        create(:transaction, user: user, customer: customer, expiry: Time.now)
      end

      api_authorization_header(user)
      get :total
      @stat_response = json_response[:data]
    end

    it { expect(@stat_response[:total_customers]).to eql 2 }
    it { expect(@stat_response[:total_transactions]).to eql 6 }
    it { expect(@stat_response[:total_gains]).to eql 1200 }
    it { should respond_with 200 }
  end

  describe 'GET #month' do
    before(:each) do
      create(:customer, user: user)
      customer = create(:customer, user: user)
      3.times do
        create(
          :transaction,
          user: user,
          customer: customer,
          created_at: Time.now - 30 * 24 * 60 * 60,
          expiry: Time.now - 30 * 24 * 60 * 60
        )
      end

      3.times do
        create(:transaction, user: user, customer: customer, expiry: Time.now)
      end

      api_authorization_header(user)
      get :month
      @stat_response = json_response[:data]
    end

    it { expect(@stat_response[:month_customers]).to eql 2 }
    it { expect(@stat_response[:month_transactions]).to eql 3 }
    it { expect(@stat_response[:month_gains]).to eql 600 }
    it { should respond_with 200 }
  end

  describe 'POST #customers' do
    before(:each) do
      create(:customer, user: user)
      customer = create(:customer, user: user)
      3.times do
        create(
          :transaction,
          user: user,
          customer: customer,
          created_at: Time.now - 30 * 24 * 60 * 60,
          expiry: Time.now - 30 * 24 * 60 * 60
        )
      end
      3.times do
        create(:transaction, user: user, customer: customer, expiry: Time.now)
      end

      api_authorization_header(user)
      get :customers
      @stat_response = json_response[:data]
    end

    it { expect(@stat_response.length).to eql 2 }
    it { expect(@stat_response.first[:transactions_count]).to eql 6 }
    it { expect(@stat_response.last[:transactions_count]).to eql 0 }
    it { should respond_with 200 }
  end
end
