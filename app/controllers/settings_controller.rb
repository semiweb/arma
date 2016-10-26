class SettingsController < ApplicationController

  def index
    redirect_to settings_branch_watchers_path
  end
end