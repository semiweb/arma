class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @applications = Application.all
    @installations = Application.find(params[:id]).installations
    Installation.threaded_github_check(@installations)
    render 'index'
  end

end
