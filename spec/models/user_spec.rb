require "rails_helper"

describe User do
  let(:user) { build(:user) }

  it { expect(user).to respond_to(:email) }
  it { expect(user).to respond_to(:password) }
  it { expect(user).to respond_to(:transactions) }
  it { expect(user).to be_valid }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
end
