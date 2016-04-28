class Customer < ActiveRecord::Base
  belongs_to :user
  validates :phone, presence: true
  validates :name, presence: true
  validates :user, presence: true
end
