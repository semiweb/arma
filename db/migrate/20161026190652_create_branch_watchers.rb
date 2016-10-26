class CreateBranchWatchers < ActiveRecord::Migration
  def change
    create_table :branch_watchers do |t|
      t.integer :application_id
      t.string :branch_name
      t.string :color

      t.timestamps
    end
  end
end
