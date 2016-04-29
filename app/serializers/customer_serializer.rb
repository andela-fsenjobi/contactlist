class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :referer
end
