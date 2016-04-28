FactoryGirl.define do
  factory :transaction do
    status "Paid"
    customer
    amount 200
    user

    trait :unpaid do
      status "Unpaid"
      amount 0
    end
  end
end
