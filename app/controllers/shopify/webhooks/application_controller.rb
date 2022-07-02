# frozen_string_literal: true

module Shopify
  module Webhooks
    class ApplicationController < ActionController::Base
      include ShopifyApp::WebhookVerification unless ENV["RAILS_ENV"] == "test"

      TOPICS = {
        app_uninstalled: "app/uninstalled",
        product_updated: "products/update"
      }.freeze

      def job_params_for(params, topic)
        {
          topic: topic,
          shop_domain: params["domain"] || shop_domain,
          body: params
        }
      end

      private

      def shop_domain
        request.headers["HTTP_X_SHOPIFY_SHOP_DOMAIN"]
      end
    end
  end
end
