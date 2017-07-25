class CreateChangelogReports < ActiveRecord::Migration
  def change
    create_table :changelog_reports do |t|
      t.integer :installation_id, null: true
      t.integer :application_id, null: true
      t.text :content
      t.string :name, null: false
      t.timestamp :sent
      t.timestamps
    end
    create_table :changelog_reports_changelogs  do |t|
      t.integer :changelog_id
      t.integer :changelog_report_id
    end
  end
end
