class StatesController < ApplicationController

  def index
    @installation = Installation.find(params[:installation_id])
    @states = @installation.states.order('created_at DESC')
  end

  def diff
    @diff = State.find(params[:id]).diff
    render layout: false
  end
end
