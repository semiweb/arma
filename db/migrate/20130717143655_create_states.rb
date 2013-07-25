class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :ref
      t.string :branch
      t.boolean :local_changes
      t.text :diff
      t.references :installation, index: true

      t.timestamps
    end
  end
end
