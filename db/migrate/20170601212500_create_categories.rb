class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :application_id
      t.string :name
      t.timestamps
    end

    create_table :categories_changelogs do |t|
      t.integer :category_id
      t.integer :changelog_id
    end

  end
end
