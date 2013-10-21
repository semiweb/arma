class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :ref
      t.string :branch
      t.text :diff
      t.integer :local_commits
      t.string :github_repo
      t.datetime :commit_date
      t.references :installation, index: true

      t.timestamps
    end
  end
end
