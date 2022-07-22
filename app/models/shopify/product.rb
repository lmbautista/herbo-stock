# frozen_string_literal: true

module Shopify
  class Product < Base
    attribute :id, Integer
    attribute :shop_id, Integer
    attribute :title, String
    attribute :body_html, String
    attribute :vendor, String
    attribute :product_type, String
    attribute :handle, String
    attribute :status, String
    attribute :tags, String
    attribute :images, [Shopify::ProductImage]
    attribute :variants, [Shopify::ProductVariant]

    def save_with_response
      id.blank? ? create : update
    end

    def resource_key
      "product"
    end

    private

    def load
      path = "products/#{id}.json"
      url, headers, = prepare_request(shop_id, path, {})

      with_response_handler(200) { RestClient.get(url, headers) }
    end

    def create
      path = "products.json"
      request_attributes = attributes.except(:id, :shop_id)
      url, headers, params = prepare_request(shop_id, path, request_attributes)

      with_response_handler(201) { RestClient.post(url, params, headers) }
    end

    def update
      product_id = update_attributes.delete(:id)
      path = "products/#{product_id}.json"
      request_attributes = update_attributes.except(:shop_id)
      url, headers, params = prepare_request(shop_id, path, request_attributes)

      with_response_handler(200) { RestClient.put(url, params, headers) }
    end

    def update_attributes # rubocop:disable Metrics/AbcSize
      return @update_attributes if defined?(@update_attributes)
      return attributes if id.blank?

      session = ShopifyAPI::Utils::SessionUtils
        .load_offline_session(shop: ::Shop.find(shop_id).shopify_domain)
      shopify_product_attrs = ::ShopifyAPI::Product.find(session: session, id: id)
        .as_json.deep_symbolize_keys

      @update_attributes = attributes.dup.tap do |attrs|
        attrs[:variants][0][:id] = shopify_product_attrs[:variants][0][:id]
      end
    end
  end
end
