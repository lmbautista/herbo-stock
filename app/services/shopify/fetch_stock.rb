# frozen_string_literal: true

module Shopify
  class FetchStock
    include WithAudit

    def initialize(params)
      @shop_domain = params[:shop]
      @sku = params[:sku]
      @params = params
    end

    def call
      return no_products_response if shop.blank?

      with_audit(operation_id: operation_id, params: params.to_h, shop: shop) do
        products = V1::Product.where(shop: shop)
        products = products.where(sku: sku) if sku.present?

        return no_products_response if products.empty?

        response_success(products)
      end
    end

    private

    attr_reader :params,
                :shop_domain,
                :sku

    def operation_id
      "Fetch products stock"
    end

    def shop
      @shop ||= ::Shop.find_by(shopify_domain: shop_domain)
    end

    def response_success(products)
      message = "Stock for products with SKU #{products.pluck(:sku).to_sentence} will be updated "\
                "in Shopify"
      resource = products.pluck(:sku, :disponible).to_h

      Response.success(message, resource)
    end

    def no_products_response
      message = "Products not found"
      Response.success(message, {})
    end
  end
end
