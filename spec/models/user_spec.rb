require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  it { expect(user).to respond_to(:email) }
  it { expect(user).to respond_to(:password) }
  it { expect(user).to be_valid }

  describe 'when email is not present' do
    let(:user) { FactoryGirl.build(:user, email: '') }

    it { expect(user).not_to be_valid }
  end
end
