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

    def save_with_response
      id.blank? ? create : update
    end

    def resource_key
      "product"
    end

    private

    def create
      path = "products.json"
      request_attributes = attributes.except(:id, :shop_id)
      url, headers, params = prepare_request(shop_id, path, request_attributes)

      with_response_handler(201) { RestClient.post(url, params, headers) }
    end

    def update
      product_id = attributes.delete(:id)
      path = "products/#{product_id}.json"
      request_attributes = attributes.except(:shop_id)
      url, headers, params = prepare_request(shop_id, path, request_attributes)

      with_response_handler(200) { RestClient.put(url, params, headers) }
    end
  end
end
