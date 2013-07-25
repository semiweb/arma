class StatesController < ApplicationController
  layout false

  def index
    @states = Installation.find(params[:installation_id]).states.reverse
    respond_to do |format|
      format.js
    end
  end

  def diff
    @diff = State.find(params[:id]).diff
  end
end
