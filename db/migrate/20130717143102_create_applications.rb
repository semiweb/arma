class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
