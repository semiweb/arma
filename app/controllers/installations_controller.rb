class InstallationsController < ApplicationController

  before_action :set_installation, only: [:show,:update,:destroy]
  layout 'application', :only => :index

  def index
    @application = Application.find(params[:application_id])
    @installations = @application.installations.includes(:states)
    Installation.threaded_git_check(@installations, @application)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @states = @installation.states.limit(10).order('created_at DESC')
    Installation.threaded_git_check([@installation], @installation.application)
    @server_monitors = @installation.server_monitors.take(5)
    render layout: "application"
  end

  def update

    params[:affected] =  params[:affected_list].to_a.join(';') if params[:affected_list].present?
    if params[:server_monitor].present? && params[:server_monitor] == "true" && @installation.host.empty?
      flash[:danger] = 'You need to specify "Installation host" for server status monitor to work'
      return redirect_to application_installation_path(@installation.application, @installation)
    end

    @installation.update_attributes(installation_params)
    Installation.ping_all_installation(@installation.application.id)

    if @installation.valid?
      flash[:success] = 'Installation updated'
    else
      flash[:danger] = 'Something happened!'
    end

    respond_to do |format|
      format.js {   render :js => ''}
      format.html {redirect_to application_installation_path(@installation.application, @installation) }
    end
  end

  def destroy
    @installation.destroy
    redirect_to application_path(@installation.application)
  end

  private
  def set_installation
    @installation = Installation.find(params[:id])
  end

  def installation_params
    params.permit(:name, :location, :env, :show_changelog_count, :notes, :last_monitor_check, :changelog, :server_monitor, :login_check, :affected, :host)
  end

end
