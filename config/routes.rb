Rails.application.routes.draw do

  get 'weeks/show'
  get '/auth/:provider/callback', to: 'sessions#create'

  get '/teams/update_data'
  resources :teams, only: [:index, :show] do
    resources :weeks, only: [:show]
  end

  get '/teams/update_eliminator'
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
