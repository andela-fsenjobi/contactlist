module CanPaginate
  def paginate(page = 1, limit = 20)
    page = get_page(page)
    limit = get_limit(limit)
    offset((page - 1) * limit).limit(limit)
  end

  def get_page(page)
    page = page.to_i
    return 1 if page <= 0
    page
  end

  def get_limit(limit)
    limit = limit.to_i
    return 20 if limit < 1
    return 100 if limit > 100
    limit
  end
end
