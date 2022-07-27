# frozen_string_literal: true

require "test_helper"

module Catalog
  class ScheduledLoaderTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test "has audit" do
      assert_includes ScheduledLoader.included_modules, WithAudit
    end

    test "success creating catalog loader scheduler" do
      shop = create(:shop)

      freeze_time do
        process_id = "abc1234"
        repeat_at = 1.minute.from_now
        job_params = {
          shop_domain: shop.shopify_domain,
          repeat: true,
          repeat_at: repeat_at,
          process_id: process_id
        }
        message = "Catalog loaded scheduled at #{repeat_at}"

        SecureRandom.stubs(:hex).returns(process_id)

        assert_difference "CatalogLoaderScheduler.count", +1 do
          assert_enqueued_with job: ::CatalogLoaderJob,
                               args: [job_params],
                               queue: "default" do
            response = ScheduledLoader.new("minutes", 1, shop.shopify_domain).call

            assert response.success?
            assert_equal message, response.value
          end
        end
      end
    end

    test "success updating catalog loader scheduler" do
      old_process_id = "abc1234"
      shop = create(:shop)
      scheduler = create(:catalog_loader_scheduler,
                         shop: shop, process_id: old_process_id, next_scheduled_at: Time.zone.now)

      freeze_time do
        new_process_id = "abc1235"
        repeat_at = 1.minute.from_now
        job_params = {
          shop_domain: shop.shopify_domain,
          repeat: true,
          repeat_at: repeat_at,
          process_id: new_process_id
        }
        message = "Catalog loaded scheduled at #{repeat_at}"

        SecureRandom.stubs(:hex).returns(new_process_id)

        assert_no_difference "CatalogLoaderScheduler.count" do
          assert_changes -> { scheduler.reload.process_id }, to: new_process_id do
            assert_enqueued_with job: ::CatalogLoaderJob,
                                 args: [job_params],
                                 queue: "default" do
              response = ScheduledLoader.new("minutes", 1, shop.shopify_domain).call

              assert response.success?
              assert_equal message, response.value
            end
          end
        end
      end
    end
  end
end
