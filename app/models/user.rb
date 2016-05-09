class User < ActiveRecord::Base
  include BCrypt
  has_many :customers
  has_many :transactions
  validates :email, presence: true
  validates :encrypted_password, presence: true

  def login
    self.is_logged_in = true
    save
  end

  def logout
    self.is_logged_in = false
    save
  end

  def password
    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

  def valid_password?(login_password)
    self.password == login_password
  end
end
