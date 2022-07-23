# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  get "/audits", to: "audits#index"
  get "/fetch_stock", to: "fetch_stock#show"
  get "/products", to: "products#index"
  get "/webhooks", to: "webhooks#index"
  post "/catalog_loader", to: "catalog_loader#create"

  namespace :shopify do
    namespace :webhooks do
      post :app_uninstalled, controller: "app_uninstalled", action: :create
      post :fulfillment_created, controller: "fulfillment_created", action: :create
      post :product_updated, controller: "product_updated", action: :create
    end
  end

  mount ShopifyApp::Engine, at: "/"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
