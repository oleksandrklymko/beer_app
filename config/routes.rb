Rails.application.routes.draw do
  root 'beers#index'

  resources :beers, only: %i[index] do
    collection do
      get :search
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
