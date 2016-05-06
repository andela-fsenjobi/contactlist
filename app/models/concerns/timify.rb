module Timify
  def by_month
    where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
  end
end
