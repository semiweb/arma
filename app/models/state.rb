class State < ActiveRecord::Base
  belongs_to :installation

  validates :ref, presence: true

  def behind_by
    if github_repo
      headers = `curl -u "$ARMA_GITHUB_USERNAME:$ARMA_GITHUB_PASSWORD" -I https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/compare/master...#{ref}`

      if headers.include? 'Status: 200 OK'
        return JSON.parse(`curl -u "$ARMA_GITHUB_USERNAME:$ARMA_GITHUB_PASSWORD" https://api.github.com/repos/$ARMA_GITHUB_USERNAME/#{github_repo}/compare/master...#{ref}`)['behind_by']
      end

      return 0
    end
  end
end
