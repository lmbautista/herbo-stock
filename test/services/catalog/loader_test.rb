# frozen_string_literal: true

require "test_helper"

module Catalog
  class LoaderTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test "has audit" do
      assert_includes Loader.included_modules, WithAudit
    end

    test "success" do
      shop = create(:shop)
      loader = Loader.new(file_fixture("raw_catalog.csv"), shop.id)
      external_id = 7_734_581_887_222
      expected_shopify_response = Response.success(Shopify::Product.new(id: external_id))

      stub_shopify_product(expected_shopify_response)

      assert_difference "Audit.succeeded.count", +1 do
        assert_difference "V1::Product.count", +1 do
          response = loader.call

          assert response.success?
          assert V1::ProductExternalResource.exists?(external_id: external_id)
        end
      end
    end

    test "success with filtered product ids" do
      shop = create(:shop)
      loader = Loader.new(file_fixture("raw_catalog.csv"), shop.id, 1004)

      assert_difference "Audit.succeeded.count", +1 do
        assert_no_difference "V1::Product.count" do
          response = loader.call

          assert response.success?
        end
      end
    end

    test "fails due to shopify upsert" do
      shop = create(:shop)
      loader = Loader.new(file_fixture("raw_catalog.csv"), shop.id)
      error_message = :shopify_error

      expected_shopify_response = Response.failure(error_message)
      stub_shopify_product(expected_shopify_response)

      assert_difference "Audit.failed.count", +1 do
        assert_difference "V1::Product.count", +1 do
          response = loader.call

          assert response.failure?
          assert_equal error_message.to_s, response.value
        end
      end
    end

    test "fails due to raw adapter" do
      shop = create(:shop)
      loader = Loader.new(file_fixture("raw_catalog.csv"), shop.id)
      error_messages = %w(error1 error2)
      expected_error = "V1::Product#1003: #{error_messages.to_sentence}"

      mock_products_raw_adapter(error_messages)

      assert_difference "Audit.failed.count", +1 do
        assert_no_difference "V1::Product.count" do
          response = loader.call

          assert response.failure?
          assert_equal expected_error, response.value
        end
      end
    end

    private

    def mock_products_raw_adapter(error_messages)
      ar_errors = mock
      ar_errors.expects(:full_messages).returns(Array.wrap(error_messages))

      V1::Product.any_instance.stubs(:save).returns(false)
      V1::Product.any_instance.stubs(:errors).returns(ar_errors)
    end

    def stub_shopify_product(response)
      ::Shopify::Product.any_instance
        .stubs(:save_with_response)
        .returns(response)
    end
  end
end
