FactoryGirl.define do
  factory :application do
    name
    installations { [] }
  end
end

FactoryGirl.define do
  sequence :name do |n|
    "Nagano#{n}"
  end
end