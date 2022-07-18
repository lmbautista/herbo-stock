# frozen_string_literal: true

module Shopify
  module FulfillmentServices
    class Distribudiet
      SERVICE_NAME = "Distribudiet Fulfillment"

      def initialize(shop_id)
        @shop_id = shop_id
      end

      private

      attr_reader :shop_id

      delegate_missing_to :shopify_fulfillment_service

      def shopify_fulfillment_service
        @shopify_fulfillment_service ||= find_or_create_fulfillment_service
      end

      def find_or_create_fulfillment_service
        find_fulfillment_service || create_fulfillment_service
      end

      def find_fulfillment_service
        ShopifyAPI::FulfillmentService.all(session: session)
          .to_a.find { _1.name == SERVICE_NAME }
      end

      def create_fulfillment_service
        fulfillment_service = ShopifyAPI::FulfillmentService.new(session: session)
        fulfillment_service.name = SERVICE_NAME
        fulfillment_service.callback_url = ENV.fetch("HOST", nil)
        fulfillment_service.inventory_management = true
        fulfillment_service.tracking_support = false
        fulfillment_service.requires_shipping_method = false
        fulfillment_service.format = "json"
        fulfillment_service.save

        fulfillment_service
      end

      def session
        ShopifyAPI::Utils::SessionUtils.load_offline_session(shop: shop.shopify_domain)
      end

      def shop
        @shop ||= ::Shop.find(shop_id)
      end
    end
  end
end
