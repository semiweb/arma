Arma::Application.routes.draw do
  devise_for :users
  resources :applications, only: [:index] do
    resources :installations, only: [:index] do
      resources :states, only: [:index] do
        member do
          get :diff
        end
      end
    end
  end

  get 'authentication', to: 'authentications#authentication'
  post 'authenticate', to: 'authentications#authenticate'

  post 'collect', to: 'api#collect'

  root to: 'applications#index'
end
