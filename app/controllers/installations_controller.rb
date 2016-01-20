class InstallationsController < ApplicationController
  before_action :set_installation, only: [:show,:update,:destroy]
  layout false

  def index
    @installations = Application.find(params[:application_id]).installations.includes(:states)
    Installation.threaded_github_check(@installations)

    respond_to do |format|
      format.js
    end
  end

  def show
    @states = @installation.states.limit(10).order('created_at DESC')
    Installation.threaded_github_check([@installation])

    render layout: "application"
  end

  def update
    if @installation.update(installation_params)
      flash[:danger] = "Installation updated"
    else
      flash[:danger] = "Something happened!"
    end
    redirect_to application_installation_path(@installation.application, @installation)
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
      params.require(:installation).permit!
    end

end
