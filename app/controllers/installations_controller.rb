class InstallationsController < ApplicationController
  layout false

  def index
    @installations = Application.find(params[:application_id]).installations.includes(:states)
    @installations.each { |i| i.states.reverse! }

    Installation.threaded_github_check(@installations)

    respond_to do |format|
      format.js
    end
  end
end
