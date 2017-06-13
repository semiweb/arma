class ServerMonitor < ActiveRecord::Base
  belongs_to :installation
  UP = 'up'.freeze
  DOWN = 'down'.freeze
  LOGIN_DOWN = 'login_down'.freeze
  NEED_REFRESH = 'need_refresh'.freeze
  STATUSES = [UP,LOGIN_DOWN,DOWN].freeze

  validates :time_start, presence: true
  validates :installation_id, presence: true
  validates :status , inclusion: { in: STATUSES }

  default_scope { order(time_start: :desc) }

end
