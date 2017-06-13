class AddGitrepoToApplications < ActiveRecord::Migration
  def up
    add_column :applications, :github_repo, :string

    execute "UPDATE applications SET github_repo = 'nagano' WHERE name = 'Nagano3'"
    execute "UPDATE applications SET github_repo = 'mobia' WHERE name = 'Mobia'"
    execute "UPDATE applications SET github_repo = 'upsilon' WHERE name = 'Upsilon2'"
  end

  def down
    remove_column :applications, :github_repo
  end
end
