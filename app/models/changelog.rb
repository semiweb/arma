class Changelog < ActiveRecord::Base
  belongs_to :commit
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :changelog_reports

  validates :commit_id, presence: true

  require 'changelogs_parser'
  KEYWORDS = ChangelogsParser::ALLOWED_KEYWORDS
  AFFECTED  = ChangelogsParser::ALLOWED_AFFECTED

  include Comparable
  def <=>(another)
    return self.commit <=> another.commit
  end

  def self.never_reported(application_id)
    all_commits = Commit.where(application_id: application_id)
    return Changelog.where(commit_id: all_commits).select{ |x| !x.reported?() }
  end

  def reported?()
    self.changelog_reports.count > 0
  end

end
