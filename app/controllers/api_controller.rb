class ApiController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token

  def collect
    head :forbidden and return unless params[:authorization_key] == ENV['ARMA_AUTHORIZATION_KEY']

    ActiveRecord::Base.transaction do
      begin
        application = Application.find_or_create_by!(application_params)
        installation = application.installations.find_or_create_by!(installation_params)

        # does not create a new state if commit received = last commit but update the updated_at
        unless Rails.env.production? && installation.states.last.try(:ref) == state_params['ref']
          installation.states.create!(state_params)
        else
          installation.states.last.touch
        end
      rescue => e
        head :unprocessable_entity and return
      end
    end

    head :ok
  end

  private
    def application_params
      params.require(:application).permit!
    end

    def installation_params
      params.require(:installation).permit!
    end

    def state_params
      params.require(:state).permit!
    end
end
