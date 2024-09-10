Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :geolocations, except: [:index, :update]
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
