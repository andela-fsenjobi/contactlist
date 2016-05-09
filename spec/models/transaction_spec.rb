require "rails_helper"

describe Transaction do
  let(:transaction) { build(:transaction) }

  it { expect(transaction).to respond_to(:customer) }
  it { expect(transaction).to respond_to(:user) }
  it { expect(transaction).to respond_to(:status) }
  it { expect(transaction).to respond_to(:amount) }
  it { expect(transaction).to respond_to(:expiry) }
  it { expect(transaction).to be_valid }

  it { is_expected.to validate_presence_of :customer }
  it { is_expected.to validate_presence_of :expiry }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to_not validate_presence_of :status }
  it { is_expected.to_not validate_presence_of :amount }

  context "when amount is not specified" do
    it "should set default status to Unpaid" do
      transaction = create(:transaction, amount: 0, status: nil)
      expect(transaction.status).to eq "Unpaid"
    end
  end

  context "when amount is specified" do
    it "sets default status to Paid" do
      transaction = create(:transaction, amount: 100, status: nil)
      expect(transaction.status).to eq "Paid"
    end
  end
end
