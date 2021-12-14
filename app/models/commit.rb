class Commit < ActiveRecord::Base

  belongs_to :application
  has_many :changelogs,  :dependent => :destroy
  validates :ref, presence: true, uniqueness: true
  scope :has_changelogs, -> { joins(:changelogs).distinct }

  include Comparable
  @@child_of = {}
  def <=>(another)
    return 0 if self.ref == another.ref
    @@child_of[[self.ref, another.ref]] ||= begin
      system("git -C #{self.application.git_local_path} merge-base --is-ancestor #{self.ref} #{another.ref}") ? -1 : 1
    end
  end

  def self.invalidate_cache
    @@child_of = {}
  end

  #Overwrite of find_by_ref givin by rails
  def self.find_by_ref(sha, application_id)
    commit = Commit.where(ref: sha).first
    application = Application.find(application_id)
    if commit.nil?
      require 'git_helper'
      GitHelper.parse_git_log(application.git_local_path,application_id, sha)
      commit = Commit.where(ref: sha).first
    end
    return commit
  end

end
