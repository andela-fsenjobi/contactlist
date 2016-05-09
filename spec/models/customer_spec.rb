require "rails_helper"

describe Customer do
  let(:customer) { build(:customer) }

  it { expect(customer).to respond_to(:phone) }
  it { expect(customer).to respond_to(:name) }
  it { expect(customer).to respond_to(:user) }
  it { expect(customer).to respond_to(:referer) }
  it { expect(customer).to respond_to(:transactions) }
  it { expect(customer).to be_valid }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :phone }
  it { is_expected.to_not validate_presence_of :referer }
end
