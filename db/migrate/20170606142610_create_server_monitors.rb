class CreateServerMonitors < ActiveRecord::Migration
  def change
    create_table :server_monitors do |t|
      t.integer :installation_id
      t.string :status
      t.timestamp :time_start
      t.timestamp :time_end
      t.timestamps
    end
  end
end
