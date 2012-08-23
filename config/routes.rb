Rankings::Application.routes.draw do
    root :to => 'home#index'

    match "/ranking" => 'players#ranking'

    match "/recalculate" => 'games#recalculate'

    resources :games, :players

end
