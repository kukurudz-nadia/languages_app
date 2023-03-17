Rails.application.routes.draw do
  resources :languages, only: [:index]
  root "homes#index"
end
