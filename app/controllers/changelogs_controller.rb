class ChangelogsController < ApplicationController

  before_action :set_commit, only: [:create, :destroy, :update]
  before_action :set_changelog, only: [:update, :destroy]

  def index
    @installation = Installation.find(params[:installation_id])
    @last_state = @installation.states.last
    @changelog_waiting = Changelog.all.includes(:changelog_reports, commit:[:application])
  end

  def destroy
    if @changelog.destroy
      flash[:success] = "Commit's changelogs deleted successfully"
    else
      flash[:danger] = "Commit's changelogs cannot be deleted"
    end
    respond_to do |format|
      format.js { render 'changelogs/destroy' }
      format.html { return redirect_to application_commit_path(@commit.application_id, @commit.ref) }
    end
  end

  def create
    @changelog  = @commit.changelogs.create
    if @changelog.valid?
      flash[:success] = "Commit's changelogs new created successfully"
    end
    respond_to do |format|
      format.html { return redirect_to application_commit_path(@commit.application_id, @commit.ref) }
    end
  end

  def update
    if params['update.x'].present? || !params[:update].nil?
      @changelog.update_attributes(keyword: params[:keyword], affected: params[:affected], content: params[:content], categories: @commit.application.categories.where(id: [params[:categories]]))
    end

    case params[:action_to]
      when 'ignore'
        @changelog.update_attributes(ignored: true)
      when 'unignore'
        @changelog.update_attributes(ignored: false)
      when 'update_from_index'
      @changelog.update_attributes(content: params[:content], categories: Category.where(id: params[:categories]))
    end

    respond_to do |format|
      format.js { render 'changelogs/update' }
      format.html { return redirect_to application_commit_path(@commit.application_id,@commit.ref) }
      format.json { render :json => {changelog:@changelog , categories: @changelog.categories} }
    end
  end

  def dragsave
    respond_to do |format|
      format.json {
        ChangelogReport.find(params[:report_id]).update_attributes(content: params[:content])
        render :json => 'succès'
      }
    end
  end

  private
  def set_commit
    @commit = Commit.where(ref: params[:commit_id]).first
  end

  def set_changelog
    @changelog = @commit.changelogs.find(params[:id])
  end

end
