class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  validates :user, presence: true
  validates :customer, presence: true
end
