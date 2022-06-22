# frozen_string_literal: true

require "rest_client"
require "json"

module Shopify
  module Shop
    class Uninstall
      def initialize(shop_id)
        @shop = ::Shop.find(shop_id)
      end

      def call
        destroy_remote
          .and_then { destroy_local }
      end

      private

      attr_reader :shop

      def destroy_remote
        revoke_url = "https://#{shop.shopify_domain}/admin/api_permissions/current.json"
        headers = {
          "X-Shopify-Access-Token" => shop.shopify_token,
          content_type: "application/json",
          accept: "application/json"
        }

        RestClient.delete(revoke_url, headers)
          .then { _1.code == 200 ? Response.success(:ok) : response_failure(_1) }
      rescue StandardError => e
        response_failure(e.response)
      end

      def destroy_local
        shop.destroy.then do |success|
          return Response.success(:ok) if success

          Response.failure(shop.errors.full_messages.to_sentence)
        end
      end

      def response_failure(response)
        error_message = [response.code, response.body].join(" - ")

        Response.failure(error_message)
      end
    end
  end
end
