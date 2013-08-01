FactoryGirl.define do
  factory :state do
    ref           'fd4ae302e7f1a5a58b1abe50cedf240ea2ddb12c'
    branch        'master'
    local_commits 0
    local_changes false
    diff          'diff text'
    github_repo   'repo'
    installation
  end
end