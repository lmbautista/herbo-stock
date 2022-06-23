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

    class << self
      def resource_key
        "product"
      end

      def create(shop_id:, attributes:)
        path = "products.json"
        url, headers, params = prepare_request(shop_id, path, attributes)

        with_response_handler(201) { RestClient.post(url, params, headers) }
      end
    end
  end
end
