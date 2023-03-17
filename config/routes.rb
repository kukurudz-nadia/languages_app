Rails.application.routes.draw do
  resources :languages, only: [:index, :show]
  get "/search-by-name", to: "languages#search_by_name", as: "search_by_name"
  get "/search-by-type", to: "languages#search_by_type", as: "search_by_type"
  get "/search-by-designer", to: "languages#search_by_designer", as: "search_by_designer"
  root "homes#index"
end
