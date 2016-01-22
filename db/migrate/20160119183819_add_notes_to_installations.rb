class AddNotesToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :notes, :text, default: nil
  end
end
