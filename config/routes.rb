Rails.application.routes.draw do

  # resources :todos
  # devise_for :users
  # # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "home#api_list"

  scope module: 'api' do
    # From here Api routes for Mobile App starts
    namespace :v1 do

      resources :todos

      resources :sessions, only: [], path: '' do
        collection do
          post 'login', to: 'sessions#create' # /v1/login
          post 'signup'                       # /v1/signup
        end
      end
    end

  end

end
