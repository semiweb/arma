class CommitsController < ApplicationController
  before_action :set_application, only: [:show,:update]
  before_action :set_commit, only: [:show,:update]

  def show
    redirect_to root_path if @commit.nil?
  end

  def index
    @application = Application.find(params[:application_id])
    @changelogs = Changelog.where(commit_id: @application.commits).references(:commit).includes(:categories,commit:[:application]).sort.reverse
  end

  def update
    if params[:changelogs].blank?
      flash[:danger] = 'Nothing to save'
    else
      params[:changelogs].each do |a|
        @commit.changelogs.find(a['id']).update(keyword: a['keyword'], affected: a['affected'], content: a['content'])
      end
      flash[:success] = "Commit's changelogs updated successfully"
    end
    redirect_to application_commit_path(@application.id, @commit.ref)
  end

  private
  def set_application
    @application = Application.find(params[:application_id])
  end

  def set_commit
    @commit = @application.commits.where(ref: params[:id]).first
    if @commit.nil? && @application.git_local_path.present?
      require 'git_helper'
      GitHelper.parse_git_log(@application.git_local_path,params[:application_id], params[:id])
      @commit = @application.commits.where(ref: params[:id]).first
    end
  end

end
