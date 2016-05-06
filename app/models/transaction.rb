class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer, counter_cache: true
  validates :user, presence: true
  validates :customer, presence: true
  validates :expiry, presence: true
  before_save :set_status

  extend CanPaginate
  extend Timify

  def set_status
    self.status = amount > 0 ? "Paid" : "Unpaid"
  end
end
