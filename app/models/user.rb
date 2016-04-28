class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def login
    self.is_logged_in = true
    self.save
  end

  def logout
    self.is_logged_in = false
    self.save
  end
end
