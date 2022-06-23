# frozen_string_literal: true

require "rest_client"

module Shopify
  class Base
    include Virtus.model

    class << self
      def resource_key
        raise NotImplementedError
      end

      private

      def prepare_request(shop_id, path, attributes)
        shop = ::Shop.find(shop_id)
        url = URI.join(base_api_url_for(shop), path).to_s
        headers = {
          "X-Shopify-Access-Token" => shop.shopify_token,
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }

        params = { resource_key => attributes } if attributes.present?

        [url, headers, params]
      end

      def base_api_url_for(shop)
        "https://#{shop.shopify_domain}/admin/api/#{shop.api_version}/"
      end

      def with_response_handler(success_http_code)
        response = yield
        return response_failure(response) unless response.code == success_http_code

        parsed_body = JSON.parse(response.body)[resource_key]
        Response.success(new(parsed_body))
      end

      def response_failure(response)
        error_message = [response.code, response.body].join(" - ")

        Response.failure(error_message)
      end

      def assign_attributes(resource, attributes)
        attributes.each do |key, value|
          resource.send("#{key}=".to_sym, value)
        end
      end
    end
  end
end
