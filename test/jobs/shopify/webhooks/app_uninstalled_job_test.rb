# frozen_string_literal: true

require "test_helper"

module Shopify
  module Webhooks
    class AppUninstalledJobTest < ActiveJob::TestCase
      test "with audit" do
        assert_includes AppUninstalledJob.included_modules, WithAudit
      end

      test "#handle" do
        shop = create(:shop)
        job_params = {
          topic: "app/uninstalled",
          shop_domain: shop.shopify_domain,
          body: webhook_params
        }

        assert_enqueued_with job: AppUninstalledJob, args: [job_params], queue: "default" do
          AppUninstalledJob.handle(**job_params)
        end
      end

      test "webhook succeeded" do
        shop = create(:shop)
        job_params = {
          topic: "app/uninstalled",
          shop_domain: shop.shopify_domain,
          body: webhook_params
        }
        expected_message = "App was uninstalled successfully from shop #{shop.shopify_domain}"

        assert_difference "V1::Webhook.succeeded.count", +1 do
          assert_difference "::Shop.count", -1 do
            response = AppUninstalledJob.new.perform(**job_params)

            assert response.success?
            assert_equal expected_message, response.value
          end
        end
      end

      test "webhook failed" do
        shop = create(:shop)
        job_params = {
          topic: "app/uninstalled",
          shop_domain: shop.shopify_domain,
          body: webhook_params
        }
        expected_message = "Shop##{shop.id}: whatever goes wrong"

        ar_errors = mock
        ar_errors.expects(:full_messages).returns(Array.wrap("whatever goes wrong"))

        ::Shop.any_instance.stubs(:destroy).returns(false)
        ::Shop.any_instance.stubs(:errors).returns(ar_errors)

        assert_difference "V1::Webhook.failed.count", +1 do
          assert_no_difference "::Shop.count" do
            response = AppUninstalledJob.new.perform(**job_params)

            assert response.failure?
            assert_equal expected_message, response.value
          end
        end
      end

      private

      def webhook_params
        {
          "id" => 64_975_208_694,
          "name" => "herbomadrid-test",
          "email" => "lmiguelbautista@gmail.com",
          "domain" => "herbomadrid-test.myshopify.com",
          "province" => "Madrid"
        }
      end
    end
  end
end
