# frozen_string_literal: true

require "test_helper"

module Shopify
  module Shop
    class UninstallTest < ActiveSupport::TestCase
      test "success" do
        shop = create(:shop)
        stub_destroy_request(shop)

        response = Uninstall.new(shop.id).call
        assert response.success?
      end

      private

      def stub_destroy_request(shop)
        url = "https://#{shop.shopify_domain}/admin/api_permissions/current.json"
        stub_request(:delete, url)
          .with(
            headers: {
              "Accept" => "application/json",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/json",
              "Host" => shop.shopify_domain,
              "X-Shopify-Access-Token" => shop.shopify_token
            }
          )
          .to_return(status: 200, body: "", headers: {})
      end
    end
  end
end
