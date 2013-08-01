class AddLocalCommitsToStates < ActiveRecord::Migration
  def change
    add_column :states, :local_commits, :integer
  end
end
