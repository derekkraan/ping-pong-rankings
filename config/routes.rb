Rankings::Application.routes.draw do
  root :to => 'application#index'

  get '/auth/google_oauth2/callback', to: 'sessions#create'

  resource :sessions

  resources :players do
    get :ranking, on: :collection
    get :point_potential, on: :collection
    get :rating_history, on: :collection
  end

  resources :games do
    get :recalculate
  end
end
