class AddGithubRepoToStates < ActiveRecord::Migration
  def change
    add_column :states, :github_repo, :string
  end
end
