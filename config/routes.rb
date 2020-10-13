Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :users

  resources :clients do
    collection do
      get 'archived'
    end
    member do
      patch 'block', to: 'clients#block'
      patch 'unblock', to: 'clients#unblock'
    end
  end

  resources :visits do
    member do
      patch 'revival', to: 'visits#revival'
      #patch 'done', to: 'visits#done'
      patch 'cancel', to: 'visits#cancel'
    end
  end

  resources :reminders do
    member do
      patch 'done', to: 'reminders#done'
      patch 'actual', to: 'reminders#actual'
    end
  end

  get 'week', to: 'home#week'
  get 'month', to: 'home#month'


end
