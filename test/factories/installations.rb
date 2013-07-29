FactoryGirl.define do
  factory :installation do
    name     'icm'
    location 'location'
    env      'production'
    application

    factory :installation_with_states do
      states { [FactoryGirl.create(:state), FactoryGirl.create(:state)] }
    end
  end
end