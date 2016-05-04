class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  validates :phone, presence: true
  validates :name, presence: true
  validates :user, presence: true

  extend CanPaginate

  def self.search(search)
    where("name LIKE ? OR phone LIKE ?", "%#{search}%", "%#{search}%")
  end
end
