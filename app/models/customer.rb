class Customer < ActiveRecord::Base
  belongs_to :user
  belongs_to :referer, class_name: "Customer", foreign_key: :referer
  has_many :transactions
  validates :phone, presence: true
  validates :name, presence: true
  validates :user, presence: true

  extend CanPaginate
  extend Timify

  def self.search(search)
    search = search.downcase
    where(
      "LOWER(name) LIKE ? OR LOWER(phone) LIKE ?",
      "%#{search}%",
      "%#{search}%"
    )
  end

  def self.top
    order("transactions_count DESC")
  end
end
