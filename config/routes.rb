Arma::Application.routes.draw do
  devise_for :users
  resources :applications, only: [:index,:show] do
    resources :installations, only: [:index,:show,:update,:destroy] do

      resources :states, only: [:index] do
        member do
          get :diff
        end
      end

      resources :code_changelogs, only: [:index] do
        collection do
          post :generate_content
        end
        collection do
          post :commit
        end
        collection do
          post :toggle_show_changelog_count
        end
      end
    end
  end

  get 'settings', to: 'settings#index'
  namespace :settings do
    resources :branch_watchers
  end

  get 'authentication', to: 'authentications#authentication'
  post 'authenticate', to: 'authentications#authenticate'

  post 'collect', to: 'api#collect'

  root to: 'applications#index'
end
