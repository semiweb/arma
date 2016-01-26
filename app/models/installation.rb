class Installation < ActiveRecord::Base
  belongs_to :application
  has_many :states

  validates :name, presence: true

  default_scope { order :name, env: :desc }

  class << self
    def threaded_git_check(installations, application)
      threads = []
      git_path = "./doc/applications_git/#{application.name}/"
      `git -C #{git_path} fetch`

      installations.each do |install|
        if install.states.present?
          threads << Thread.new(install.states.last) { |s| s.check_git!(git_path) }
        end
      end
      threads.each { |t| t.join }
    end
  end

  def code_changelog_directory
    location = self.location == 'undefined' ? '' : self.location
    Rails.root.join('doc', 'changelogs', self.application.name, self.name, self.env, location).to_s.gsub(Rails.root.to_s, '.')
  end

  def nb_changelogs_uncommitted
    nb_uncommitted = CodeChangelog::ArmaCodeChangelog.new(self.code_changelog_directory).nb_uncommitted
    (nb_uncommitted == 0 || !self.show_changelog_count) ? '' : nb_uncommitted
  end
end
