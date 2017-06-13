class Installation < ActiveRecord::Base
  belongs_to :application
  has_many :states
  has_many :changelog_reports
  has_many :server_monitors

  validates :name, presence: true

  default_scope { order :name, env: :desc }

  require 'git_helper'

  class << self
    def threaded_git_check(installations, application)
      threads = []
      `git -C #{application.git_local_path} fetch`
      GitHelper.parse_git_log(application.git_local_path,application.id)
      installations.each do |install|
        if install.states.present?
          threads << Thread.new(install.states.last) { |s| s.check_git!(application.git_local_path) }
        end
      end
      threads.each { |t| t.join }
    end
  end

  def monitor_status
    #no status exist or data is not refreshed
    return ServerMonitor::NEED_REFRESH if self.server_monitors.empty? || self.last_monitor_check.nil? || Time.now - self.last_monitor_check > 1200
    self.server_monitors.order(time_start: :desc).first.status
  end

  def up?
    self.server_monitors.order(time_start: :desc).first.status == ServerMonitor::UP
  end

  def update_server_monitor(status)
    #email handling could be add here
    self.server_monitors.order(time_start: :desc).first.update_attributes(time_end: Time.now) if self.server_monitors.count > 0
    self.server_monitors.create(time_start: Time.now, status: status)
  end

  def server_status_need_refresh?
    current_status = self.server_monitors.order(time_start: :desc).first

    #no server monitor status exist or installaiton was never checked
    return true if current_status.nil? || self.last_monitor_check.nil?

    #current server is UP and last check is 10min ago
    return true if current_status.status == ServerMonitor::UP  && Time.now - self.last_monitor_check > 600

    #current server is NOT UP and last_check is 1min ago
    return true if current_status.status != ServerMonitor::UP && Time.now - self.last_monitor_check > 60

    #all other scenario, server don't need a refresh
    return false
  end

  def self.ping_all_installation(application_id)
    installations = Installation.where(application_id: application_id)
    installations.each do |installation|
      #ping only if server_monitor module is activated and need_refresh
      if installation.server_monitor && installation.server_status_need_refresh?
        installation.update_attributes(last_monitor_check: Time.now)
        current_status = installation.ping()
        installation.update_server_monitor(current_status) unless installation.monitor_status == current_status
      end
    end
    nil
  end


  def ping(host = nil, limit = 10)
    raise ArgumentError, 'too many HTTP redirects' if limit <= 0
    host = self.host+"/sessions/get_seconds_until_expiration" if host.nil?
    return ServerMonitor::NEED_REFRESH if host.empty?
    begin
      response = Net::HTTP.get_response(URI(host))
      case response
        when Net::HTTPSuccess then
          response.uri.path = "/sessions"
          if self.login_check && Net::HTTP.post_form(response.uri, 'username' => 'test', 'password' => 'test').code == "200"
            return ServerMonitor::UP
          else
            return self.login_check ? ServerMonitor::LOGIN_DOWN : ServerMonitor::UP
          end
        when Net::HTTPRedirection then
          location = response['location']
          return self.ping(location, limit - 1)
        else
          return ServerMonitor::DOWN #down status
      end
    rescue Exception
      return ServerMonitor::DOWN
    end
  end

end
