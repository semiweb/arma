class CodeChangelogEntryMigration < ActiveRecord::Migration
  def change
    create_table :arma_code_changelog_entries do |t|
      t.string :filename
      t.string :directory, index: true
      t.datetime :committed_at, default: nil

      t.timestamps
    end
  end
end
