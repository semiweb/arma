class State < ActiveRecord::Base
  belongs_to :installation

  validates :ref, presence: true

  attr_accessor :behind_by

  before_save :set_commit_date!

  def check_github!
    if github_repo && !Rails.env.test?
      headers = `curl -u "$ARMA_GITHUB_USERNAME:$ARMA_GITHUB_PASSWORD" -I https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/compare/master...#{ref}`

      if headers.include? 'Status: 200 OK'
        self.behind_by = JSON.parse(`curl -u "$ARMA_GITHUB_USERNAME:$ARMA_GITHUB_PASSWORD" https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/compare/master...#{ref}`)['behind_by']
      end
    end

    self.behind_by = behind_by.to_i
  end

  private

    def set_commit_date!
      self.commit_date = DateTime.now and return if Rails.env.test?

      if github_repo && !Rails.env.test?
        headers = `curl -u "$ARMA_GITHUB_USERNAME:$ARMA_GITHUB_PASSWORD" -I https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/git/commits/#{ref}`

        if headers.include? 'Status: 200 OK'
          self.commit_date = JSON.parse(`curl -u "$ARMA_GITHUB_USERNAME:$ARMA_GITHUB_PASSWORD" https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/git/commits/#{ref}`)['author']['date']
        end
      end
    end
end
