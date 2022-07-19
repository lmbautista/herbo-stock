# frozen_string_literal: true

# Since the source of truth would be the provider catalog in CSV, we only need to take into account
# the inventory quantity is updated by Shopify each time a product is sold or refund

module Shopify
  module Webhooks
    class ProductsUpdateJob < ApplicationJob
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
          return nothing_changed_response if product.nil? || inventory_quantity.nil?

          update_product_quantity_with_response
            .and_then { webhook_succeeded_with_response }
            .and_then { response_success }
            .on_failure { webhook_failed_with_response(_1) }
        end
      end

      private

      attr_reader :topic,
                  :shop_domain,
                  :body

      def shop
        @shop ||= ::Shop.find_by!(shopify_domain: shop_domain)
      end

      def webhook
        @webhook ||= ::V1::Webhook
          .new(topic: topic, body: body, shop_domain: shop.shopify_domain)
      end

      def product
        @product ||= ::V1::Product.joins(:product_external_resources)
          .where(shop: shop)
          .find_by(v1_product_external_resources: { external_id: body.fetch("id") })
      end

      def inventory_quantity
        body.fetch("variants", [])[0]&.fetch("inventory_quantity")
      end

      def update_product_quantity_with_response
        return Response.success(product) if product.update(disponible: inventory_quantity.to_i)

        response_failure(product)
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
        message = "Product '#{product.definicion}' with SKU #{product.sku} was updated successfully"
        Response.success(message)
      end

      def nothing_changed_response
        message = "Product not found or availability is nil"
        Response.success(message)
      end
    end
  end
end
