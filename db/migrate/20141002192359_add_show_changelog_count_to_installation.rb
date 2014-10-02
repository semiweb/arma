class AddShowChangelogCountToInstallation < ActiveRecord::Migration
  def change
    add_column :installations, :show_changelog_count, :boolean, default: true
  end
end
