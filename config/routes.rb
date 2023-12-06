Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        get 'vendors', to: 'market_vendors#index'
      end
    end
  end
end
