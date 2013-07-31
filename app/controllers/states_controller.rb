class StatesController < ApplicationController
  layout false

  def diff
    @diff = State.find(params[:id]).diff
  end
end
