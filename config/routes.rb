Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts do
    collection do
      get 'buy'
    end
  end
  resources :mypages, only: :index do
    collection do
      get 'logout'
      get 'identification'
    end
  end
  root 'posts#index'
end
