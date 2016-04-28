FactoryGirl.define do
  sequence :phone do |n|
    "0803983029#{n}"
  end

  factory :customer do
    name "Safiya"
    phone
    user
  end
end
