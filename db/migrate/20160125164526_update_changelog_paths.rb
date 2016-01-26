class UpdateChangelogPaths < ActiveRecord::Migration

  class ArmaCodeChangelogEntry < ActiveRecord::Base; end

  def up
    ArmaCodeChangelogEntry.all.each do |entry|
      if entry.directory.include? Rails.root.to_s + '/doc'
        entry.update_attribute(:directory, entry.directory.gsub(Rails.root.to_s + '/doc','./doc/changelogs'))
      end
    end
  end

  def down
    ArmaCodeChangelogEntry.all.each do |entry|
      if entry.directory.start_with? './doc/changelogs'
        entry.update_attribute(:directory, entry.directory.gsub('./doc/changelogs',Rails.root.to_s + '/doc'))
      end
    end
  end
end
