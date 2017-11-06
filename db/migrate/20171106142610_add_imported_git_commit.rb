class AddImportedGitCommit < ActiveRecord::Migration
  def up
    add_column :commits, :imported_gitlog, :boolean, default: false
  end

  def down
    remove_column :applications, :imported_gitlog
  end

end
