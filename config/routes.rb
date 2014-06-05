Rankings::Application.routes.draw do
  root :to => 'home#index'

  resources :players do
    get :ranking
  end

  resources :games do
    get :recalculate
  end
end
