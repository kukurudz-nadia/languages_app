Rails.application.routes.draw do
  resources :languages, only: [:index, :show]
  get "/search-by-name", to: "languages#search_by_name", as: "search_by_name"
  get "/search-by-type-or-designer", to: "languages#search_by_type_or_designer", as: "search_by_type_or_designer"
  root "homes#index"
end
