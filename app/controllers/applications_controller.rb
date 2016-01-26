class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @applications = Application.all
    application = Application.find(params[:id])
    @installations = application.installations
    Installation.threaded_git_check(@installations, application)

    render 'index'
  end

end
