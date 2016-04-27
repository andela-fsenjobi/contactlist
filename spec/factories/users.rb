FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@email.com"
  end

  factory :user do
    email
    password "1qw23er45t"
  end
end
