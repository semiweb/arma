class AddAttributesToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :last_monitor_check, :timestamp
    add_column :installations, :changelog, :boolean, default: false
    add_column :installations, :server_monitor, :boolean, default: false
    add_column :installations, :login_check, :boolean, default: false
    add_column :installations, :affected, :string, default: '', null: false
    add_column :installations, :host, :string, defaul: '', null: false
  end
end
