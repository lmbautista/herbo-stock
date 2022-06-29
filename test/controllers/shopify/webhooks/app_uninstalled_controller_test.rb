# frozen_string_literal: true

require "test_helper"

module Shopify
  module Webhooks
    class AppUninstalledControllerTest < ActionDispatch::IntegrationTest
      test "enqueue job successfully" do
        shop = create(:shop)
        webhook_params = webhook_params_for(shop)
        job_params = {
          topic: "app/uninstalled",
          shop_domain: shop.shopify_domain,
          body: webhook_params
        }

        assert_enqueued_with job: Shopify::Webhooks::AppUninstalledJob,
                             args: [job_params],
                             queue: "default" do
          post shopify_webhooks_app_uninstalled_path(webhook_params)

          assert_response :ok
        end
      end

      private

      def webhook_params_for(shop)
        {
          "id" => "64975208694",
          "name" => "test-shopify",
          "email" => "luismiguel.bautista@jobandtalent.com",
          "domain" => shop.shopify_domain,
          "province" => "Madrid"
        }
      end
    end
  end
end
