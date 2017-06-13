class ChangelogReport < ActiveRecord::Base

  has_and_belongs_to_many :changelogs
  belongs_to :installation
  belongs_to :application

  validates :changelogs, presence: true


  def has_changelogs?
    self.errors.add(:base,'Changelog report must have changelogs ') if self.changelogs.blank?
  end

end
