FactoryGirl.define do
  factory :user do
    username
    password 'my_password'
    password_confirmation 'my_password'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end

FactoryGirl.define do
  sequence :username do |n|
    "john#{n}"
  end
end