FactoryGirl.define do
  factory :transaction do
    status "Paid"
    customer
    amount 200
    user
    expiry Time.now + 30 * 24 * 60 * 60

    trait :unpaid do
      status "Unpaid"
      amount 0
    end
  end
end
