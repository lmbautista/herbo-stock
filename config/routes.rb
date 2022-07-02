# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  get "/products", to: "products#index"

  namespace :shopify do
    namespace :webhooks do
      post :app_uninstalled, controller: "app_uninstalled", action: :create
      post :product_updated, controller: "product_updated", action: :create
    end
  end

  mount ShopifyApp::Engine, at: "/"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
