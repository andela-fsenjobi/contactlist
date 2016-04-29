class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :status, :amount, :expiry, :created_at
end
