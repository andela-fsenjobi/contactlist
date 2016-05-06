module SaveHelper
  def save(object)
    if object.save
      render json: object, status: 201, location: [:api, object]
    else
      render json: { error: "#{object.class.name.capitalize} not created" }, status: 422
    end
  end

  def edit(object, params)
    if object.update(params)
      render json: object, status: 201, location: [:api, object]
    else
      render json: { error: "#{object.class.name.capitalize} not updated" }, status: 422
    end
  end

  def default(object, params)
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : 20
    total = object.count
    object = object.paginate(page, limit)
    render json: object, meta: {
      total_records: total,
      current_page: page
    }
  end
end
