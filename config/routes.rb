Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "application#hello"
  get "prices", to: "domain_prices#index"
  get "static_pages/about"
  get "static_pages/contact"
  get "static_pages/help"
  get "static_pages/terms"
  get "static_pages/policy"
end
