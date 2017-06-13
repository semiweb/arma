class ApplicationsController < ApplicationController
  before_action :set_application, only: [:edit,:update]

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

  def edit

  end

  def update
   if @application.update_attributes(github_repo: params[:github_repo])
     flash[:success] = 'Application configuration is saved successfully'
   else
     flash[:danger] = 'Cannnot save application configuration'
   end
   redirect_to edit_application_path
  end

  private
  def set_application
    @application = Application.find(params[:id])
  end

end
