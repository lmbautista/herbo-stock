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
      return Response.success({}) if shop.blank?

      with_audit(operation_id: self.class.to_s, params: params.to_h, shop: shop) do
        products = V1::Product.where(shop: shop)
        products = products.where(sku: sku) if sku.present?

        Response.success(products.pluck(:sku, :disponible).to_h)
      end
    end

    private

    attr_reader :params,
                :shop_domain,
                :sku

    def shop
      @shop ||= ::Shop.find_by(shopify_domain: shop_domain)
    end
  end
end
