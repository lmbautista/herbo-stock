# frozen_string_literal: true

module Shopify
  module Webhooks
    class ApplicationController < ActionController::Base
      include ShopifyApp::WebhookVerification unless ENV["RAILS_ENV"] == "test"

      TOPICS = {
        app_uninstalled: "app/uninstalled"
      }.freeze

      def job_params_for(params, topic)
        {
          topic: topic,
          shop_domain: params["domain"],
          body: params
        }
      end
    end
  end
end
