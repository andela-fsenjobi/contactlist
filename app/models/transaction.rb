class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer, counter_cache: true
  validates :user, presence: true
  validates :customer, presence: true
  validates :expiry, presence: true

  extend CanPaginate
  extend Timify
end
