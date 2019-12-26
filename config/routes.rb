Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "application#index"
  get "prices", to: "domain_prices#index"
  get "prices/:id/edit", to: "domain_prices#edit"
end
