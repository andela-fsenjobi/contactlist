require "rails_helper"

describe Customer do
  let(:transaction) { build(:transaction) }

  it { expect(customer).to respond_to(:customer) }
  it { expect(customer).to respond_to(:user) }
  it { expect(customer).to respond_to(:status) }
  it { expect(customer).to respond_to(:amount) }
  it { expect(customer).to be_valid }

  describe "when phone is not present" do
    let(:transaction) { FactoryGirl.build(:transaction, customer: "") }

    it { expect(transaction).not_to be_valid }
  end
end
