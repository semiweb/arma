class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.string :name
      t.string :location
      t.string :env
      t.references :application, index: true

      t.timestamps
    end

    add_index :installations, [:name, :location, :env]
  end
end
