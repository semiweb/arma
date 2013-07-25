FactoryGirl.define do
  factory :state do
    ref           'fd4ae302e7f1a5a58b1abe50cedf240ea2ddb12c'
    branch        'master'
    local_changes false
    diff          'diff text'
    installation
  end
end