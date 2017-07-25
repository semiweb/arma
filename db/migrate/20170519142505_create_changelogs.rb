class CreateChangelogs < ActiveRecord::Migration
  def change
    create_table :changelogs do |t|
      t.integer :commit_id
      t.string :keyword, default: '', null: false
      t.string :affected, default: '', null: false
      t.text :content
      t.boolean :ignored, default: false, null: false
      t.timestamps
    end
  end
end
