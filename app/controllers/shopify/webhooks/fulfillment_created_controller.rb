# frozen_string_literal: true

module Shopify
  module Webhooks
    class FulfillmentCreatedController < Webhooks::ApplicationController
      include WithAudit

      def create
        with_audit(operation_id: operation_id, params: params, shop: shop) do
          products_ids = products_info.map(&:id)
          products_sku = products_info.map(&:sku)

          job_params = { product_ids: products_ids, shop_domain: shop_domain }

          CatalogLoaderJob.perform_later(**job_params)

          order_url = "http://#{shop.shopify_domain}/admin/orders/#{order_id}"
          message = "<a href=\"#{order_url}\" target=\"_blank\">Order</a> was prepared. " \
                    "Products with SKU #{products_sku.to_sentence} will be updated"
          Response.success(message)
        end

        head :ok
      end

      private

      def create_params
        params.permit(:order_id, line_items: [:product_id]).to_h
      end

      def shopify_product_ids
        create_params[:line_items].map { _1[:product_id] }
      end

      def products_info
        @products_info ||= V1::ProductExternalResource
          .joins(:product)
          .where(
            external_id: shopify_product_ids,
            kind: ::V1::ProductExternalResource::KIND_SHOPIFY_PRODUCT
          )
          .pluck("v1_products.id, v1_products.sku")
          .map { |id, sku| ProductInfo.new(id, sku) }
      end

      ProductInfo = Struct.new(:id, :sku)
      private_constant :ProductInfo

      def operation_id
        "Order prepared"
      end

      def order_id
        create_params[:order_id]
      end

      def shop
        @shop ||= ::Shop.find_by(shopify_domain: shop_domain)
      end
    end
  end
end
