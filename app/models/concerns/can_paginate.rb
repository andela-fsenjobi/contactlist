module CanPaginate
  def paginate(page = 1, limit = 20)
    offset((page - 1) * limit).limit(limit)
  end
end
