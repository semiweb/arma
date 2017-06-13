class Application < ActiveRecord::Base
  has_many :installations
  has_many :commits
  has_many :categories
  has_many :changelog_reports
  validates :name, presence: true, uniqueness: true

  def git_local_path
    "#{Rails.root.join('doc', 'applications_git')}/" + self.name
  end

end
