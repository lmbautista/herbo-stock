# frozen_string_literal: true

# Required Shopify job to avoid raising ShopifyApp::MissingWebhookJobError

module Shopify
  module Webhooks
    class FulfillmentsCreateJob < ApplicationJob
      include WithAudit
      extend ShopifyAPI::Webhooks::Handler

      class << self
        def handle(args)
          perform_later(args)
        end
      end

      def perform
        # noop
      end
    end
  end
end
