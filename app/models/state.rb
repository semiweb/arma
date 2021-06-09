class State < ActiveRecord::Base
  belongs_to :installation

  validates :ref, presence: true

  attr_accessor :behind_by

  before_save :set_commit_date!

  def check_git!(git_path)

    behind_by = `git -C #{git_path} rev-list --count #{ref}..origin/#{branch}`

    self.behind_by = (behind_by == '' ? 'Problem getting the behind_by' : behind_by.to_i)

  end

  private

    def set_commit_date!
      self.commit_date = DateTime.now and return if Rails.env.test?
      return if github_repo.blank?

      result = `curl -H "Authorization: token $ARMA_GITHUB_ACCESS_TOKEN" https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/git/commits/#{ref}`

      return if result.blank?
      json = JSON.parse(result) rescue return

      if json.present? && json['author']
        self.commit_date = json['author']['date']
      end
    end
end
