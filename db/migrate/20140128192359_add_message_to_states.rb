class AddMessageToStates < ActiveRecord::Migration
  def change
    add_column :states, :message, :string
  end
end
