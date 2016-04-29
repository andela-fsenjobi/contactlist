class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :customers
  has_many :transactions

  def login
    self.is_logged_in = true
    save
  end

  def logout
    self.is_logged_in = false
    save
  end
end
