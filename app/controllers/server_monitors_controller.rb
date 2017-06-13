class ServerMonitorsController < ApplicationController

  def index
    @installation = Installation.find(params[:installation_id])
    @server_monitors = @installation.server_monitors
  end

end