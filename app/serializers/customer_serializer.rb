class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :referer, :transactions_count
end
