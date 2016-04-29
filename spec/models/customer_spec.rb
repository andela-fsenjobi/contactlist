require "rails_helper"

describe Customer do
  let(:customer) { build(:customer) }

  it { expect(customer).to respond_to(:phone) }
  it { expect(customer).to respond_to(:name) }
  it { expect(customer).to respond_to(:user) }
  it { expect(customer).to respond_to(:referer) }
  it { expect(customer).to be_valid }

  describe "when phone is not present" do
    let(:customer) { FactoryGirl.build(:customer, phone: "") }

    it { expect(customer).not_to be_valid }
  end
end
