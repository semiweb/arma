class Settings::BranchWatchersController < ApplicationController

  before_filter :set_branch_watcher, except: [:index, :new, :create]

  def index
    @branch_watchers = BranchWatcher.all
  end

  def update
    @branch_watcher.update_attributes(branch_watcher_params)
    redirect_to settings_branch_watchers_path
  end

  def destroy
    @branch_watcher.destroy
    redirect_to settings_branch_watchers_path
  end

  def new
    @branch_watcher = BranchWatcher.new
  end

  def create
    BranchWatcher.create!(branch_watcher_params)
    redirect_to settings_branch_watchers_path
  end

  private

  def set_branch_watcher
    @branch_watcher = BranchWatcher.find(params[:id])
  end

  def branch_watcher_params
    params.require(:branch_watcher).permit(:branch_name, :application_id, :color)
  end
end