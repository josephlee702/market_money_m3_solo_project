Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index], controller: "market_vendors"
      end
      resources :vendors, only: [:show, :create], controller: "vendors"
    end
  end
end
