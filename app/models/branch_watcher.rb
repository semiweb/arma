class BranchWatcher < ActiveRecord::Base
  belongs_to :application

  scope :for_application, ->(application) { where(application: application) }
  scope :for_branch_name, ->(branch_name) { where(branch_name: branch_name) }

  validates :branch_name, presence: true, uniqueness: {
      scope: :application_id,
      message: "Should be unique to application"
  }
end
