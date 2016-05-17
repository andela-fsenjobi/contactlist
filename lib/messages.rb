class Messages
  def auth_error
    "Not authenticated"
  end

  def logged_in
    "You are now logged in"
  end

  def invalid_credentials
    "Invalid login credentials"
  end

  def logged_out
    "You are logged out"
  end

  def create_error(object)
    "#{object.capitalize} not created"
  end

  def update_error(object)
    "#{object.capitalize} not updated"
  end

  def delete_message
    "Record deleted"
  end

  def invalid_endpoint
    "The end point you requested does not exist"
  end

  def debug
    "Please check the documentation for existing end points"
  end
end
