module Timify
  def by_month(column = "created_at", month = Time.now.month)
    where("cast(strftime('%m', #{column}) as int) = ?", month)
  end
end
