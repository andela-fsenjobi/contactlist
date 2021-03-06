module DefaultActions
  def save(object)
    if object.save
      render json: object, status: 201, location: [:api, object]
    else
      render json: { error: message.create_error(object.class.name.to_s) },
             status: 422
    end
  end

  def update
    if resource.update(get_params)
      render json: resource, status: 201, location: [:api, resource]
    else
      render json: { error: message.update_error(resource.class.name.to_s) },
             status: 422
    end
  end

  def index
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : 20
    total = collection.count
    collections = collection.paginate(page, limit)
    render json: collections, meta: {
      total_records: total,
      current_page: page
    }
  end

  def get_params
    send("#{controller_name.singularize}_params")
  end

  def collection
    @collection ||= instance_variable_get("@#{controller_name}")
  end

  def resource
    @resource ||= instance_variable_get("@#{controller_name.singularize}")
  end
end
