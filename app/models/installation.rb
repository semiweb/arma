class Installation < ActiveRecord::Base
  belongs_to :application
  has_many :states

  validates :name, presence: true

  class << self
    def threaded_github_check(installations)
      threads = []
      installations.each do |install|
        if install.states.present?
          threads << Thread.new(install.states.last) { |s| s.check_github! }
        end
      end
      threads.each { |t| t.join }
    end
  end
end
