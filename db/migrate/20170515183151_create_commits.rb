class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.timestamp :commit_time
      t.string :ref, null: false
      t.string :branch
      t.integer :application_id, null: false
      t.string :author
      t.boolean :downtime
      t.text :full_commit_message
      t.timestamps
    end
    add_index :commits, :ref, unique: true
    add_index :states, :created_at, unique: false
  end
end
