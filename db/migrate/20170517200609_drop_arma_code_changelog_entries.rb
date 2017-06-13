class DropArmaCodeChangelogEntries < ActiveRecord::Migration
  def up
    drop_table :arma_code_changelog_entries
  end

  def down
    create_table :arma_code_changelog_entries
  end
end
