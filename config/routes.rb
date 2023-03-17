Rails.application.routes.draw do
  resources :languages, only: [:index, :show]
  get "/search", to: "languages#search_by_name", as: "search_by_name"
  root "homes#index"
end
