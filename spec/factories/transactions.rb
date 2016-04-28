FactoryGirl.define do
  factory :tranaction do
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
