class AuthenticationsController < ApplicationController
  skip_before_action :authenticate, only: :authentication

  def authentication
  end

  def authenticate
    if params[:password] == ENV['ARMA_PASSWORD']
      cookies.permanent[:authenticated] = true
      redirect_to applications_path
    else
      render :authentication
    end
  end
end
