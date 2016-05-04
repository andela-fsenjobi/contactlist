module Timify
  def by_day(column = "created_at", day = Time.now.day)
    where("cast(strftime('%d', #{column}) as int) = ?", day)
  end

  def by_month(column = "created_at", month = Time.now.month)
    where("cast(strftime('%m', #{column}) as int) = ?", month)
  end

  def by_year(column = "created_at", year = Time.now.year)
    where("cast(strftime('%Y', #{column}) as int) = ?", year)
  end
end
