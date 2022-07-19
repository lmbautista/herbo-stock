# frozen_string_literal: true

module Shopify
  module Webhooks
    class AppUninstalledJob < ApplicationJob
      include WithAudit
      extend ShopifyAPI::Webhooks::Handler

      class << self
        def handle(topic:, shop_domain:, body:)
          perform_later(topic: topic, shop_domain: shop_domain, body: body)
        end
      end

      def perform(topic:, shop_domain:, body:)
        @topic = topic
        @shop_domain = shop_domain
        @body = body

        with_audit(operation_id: operation_id, params: body, shop: shop) do
          ActiveRecord::Base.transaction do
            destroy_shop_with_response
              .and_then { webhook_succeeded_with_response }
              .and_then { response_success }
              .on_failure { |error_messasge| webhook_failed_with_response(error_messasge) }
          end
        end
      end

      private

      attr_reader :topic,
                  :shop_domain,
                  :body

      def shop
        @shop ||= ::Shop.find_by!(shopify_domain: shop_domain)
      end

      def destroy_shop_with_response
        shop.destroy ? Response.success(shop) : response_failure(shop)
      end

      def webhook
        @webhook ||= ::V1::Webhook
          .new(topic: topic, body: body, shop_domain: shop.shopify_domain)
      end

      def webhook_succeeded_with_response
        webhook.succeeded!
        Response.success(webhook)
      end

      def webhook_failed_with_response(error_message)
        webhook.failed_with_message!(error_message)
        Response.failure(error_message)
      end

      def operation_id
        self.class.to_s
      end

      def response_failure(record)
        id_error_message = "#{record.class}##{record.id}:"
        error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

        Response.failure(error_message)
      end

      def response_success
        message = "App was uninstalled successfully from shop #{shop_domain}"

        Response.success(message)
      end
    end
  end
end
