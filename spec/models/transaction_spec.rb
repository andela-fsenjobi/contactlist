require "rails_helper"

describe Transaction do
  let(:transaction) { build(:transaction) }

  it { expect(transaction).to respond_to(:customer) }
  it { expect(transaction).to respond_to(:user) }
  it { expect(transaction).to respond_to(:status) }
  it { expect(transaction).to respond_to(:amount) }
  it { expect(transaction).to be_valid }

  describe "when phone is not present" do
    let(:transaction) { build(:transaction, customer: nil) }

    it { expect(transaction).not_to be_valid }
  end

  context "when amount is not specified" do
    it do
      transaction = create(:transaction, amount: 0, status: nil)
      expect(transaction.status).to eq "Unpaid"
    end
  end

  context "when amount is specified" do
    it do
      transaction = create(:transaction, amount: 100, status: nil)
      expect(transaction.status).to eq "Paid"
    end
  end
end
