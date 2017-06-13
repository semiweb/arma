class CreateChangelogs < ActiveRecord::Migration
  def change
    create_table :changelogs do |t|
      t.integer :commit_id
      t.string :keyword
      t.string :affected
      t.text :content
      t.boolean :ignored, :default => false
      t.timestamps
    end
  end
end
