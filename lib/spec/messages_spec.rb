require "rails_helper"

describe Messages do
  describe "#auth_error" do
    it { expect(subject.auth_error).to eq "Not authenticated" }
  end

  describe "#logged_in" do
    it { expect(subject.logged_in).to eq "You are now logged in" }
  end

  describe "#invalid_credentials" do
    it { expect(subject.invalid_credentials).to eq "Invalid login credentials" }
  end

  describe "#logged_out" do
    it { expect(subject.logged_out).to eq "You are logged out" }
  end

  describe "#create_error" do
    it { expect(subject.create_error("customer")).to eq "Customer not created" }
  end

  describe "#update_error" do
    it do
      expect(subject.update_error("transaction")).
        to eq "Transaction not updated"
    end
  end

  describe "#delete_message" do
    it { expect(subject.delete_message).to eq "Record deleted" }
  end

  describe "#invalid_endpoint" do
    it "returns invalid endpoint message" do
      expect(subject.invalid_endpoint).
        to eq "The end point you requested does not exist"
    end
  end

  describe "#debug" do
    it "returns debug message" do
      expect(subject.debug).
        to eq "Please check the documentation for existing end points"
    end
  end
end
