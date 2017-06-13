Arma::Application.routes.draw do
  devise_for :users
  resources :applications, only: [:index,:show, :edit, :update] do
    resources :categories, only: [:update,:destroy,:create]
    resources :changelog_reports, only: [ :create, :update, :destroy, :edit, :index]
    match 'drag', to: 'changelogs#dragsave', via: ['POST']
    resources :commits, only: [:show, :index, :update] do
      resources :changelogs, only: [:create,:destroy, :update]
    end
    resources :installations, only: [:index,:show,:update,:destroy] do
      resources :server_monitors, only:[:index]
      resources :changelogs, only: [:index]
      resources :states, only: [:index] do
        member do
          get :diff
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
