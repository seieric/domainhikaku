Rails.application.routes.draw do
  get 'contacts/new'
  get 'contacts/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "static_pages#index"
  get "prices", to: "domain_prices#index"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  get "help", to: "static_pages#help"
  get "terms", to: "static_pages#terms"
  get "policy", to: "static_pages#policy"
  get "search", to: "charts#index"
end
