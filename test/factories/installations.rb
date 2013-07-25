FactoryGirl.define do
  factory :installation do
    name     'icm'
    location 'location'
    env      'production'
    application
    states { [] }
  end
end