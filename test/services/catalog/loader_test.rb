# frozen_string_literal: true

require "test_helper"

module Catalog
  class LoaderTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper
    include FulfillmentServiceHelper

    teardown do
      File.delete("public/MyString") if File.exist?("public/MyString")
    end

    test "has audit" do
      assert_includes Loader.included_modules, WithAudit
    end

    test "success" do
      shop = create(:shop)
      product = create(:v1_product, shop: shop)
      external_id = 7_734_581_887_222
      expected_shopify_response = Response.success(Shopify::Product.new(id: external_id))

      stub_download_image
      stub_shopify_product(expected_shopify_response)
      mock_product_loader(product)
      mock_product_fulfillment_service(external_id, product.disponible, product)
      stub_fulfillment_service_catalog_request
      product.expects(:has_been_updated?).twice.returns(true)

      assert_difference "Audit.succeeded.count", +1 do
        with_mocked_fulfillment_service(shop) do
          response = Loader.new(shop.id).call

          assert response.success?
          assert V1::ProductExternalResource.exists?(external_id: external_id)
          assert Audit.exists?(message: expected_audit_message(product.id))
        end
      end
    end

    test "success when nothing changes" do
      shop = create(:shop)
      product = create(:v1_product, shop: shop)
      external_id = 7_734_581_887_222
      create(:v1_product_external_resource, product: product, external_id: external_id)
      expected_shopify_response = Response.success(Shopify::Product.new(id: external_id))

      stub_shopify_product(expected_shopify_response)
      mock_product_loader(product)
      stub_fulfillment_service_catalog_request
      product.expects(:has_been_updated?).twice.returns(false)

      assert_difference "Audit.succeeded.count", +1 do
        response = Loader.new(shop.id).call

        assert response.success?
        assert V1::ProductExternalResource.exists?(external_id: external_id)
        assert Audit.exists?(message: "No changes were applied")
      end
    end

    test "success with filtered product ids" do
      shop = create(:shop)

      Product::Loader.expects(:new).never

      stub_fulfillment_service_catalog_request

      assert_difference "Audit.count", +1 do
        response = Loader.new(shop.id, 1004).call

        assert response.success?
        assert Audit.exists?(message: "No changes were applied")
      end
    end

    test "fails due to shopify upsert" do
      shop = create(:shop)
      product = create(:v1_product, shop: shop)
      error_message = :shopify_error
      expected_message = "Cannot upsert Shopify product: #{error_message}"

      expected_shopify_response = Response.failure(error_message)

      stub_download_image
      stub_shopify_product(expected_shopify_response)
      mock_product_loader(product)
      stub_fulfillment_service_catalog_request
      product.expects(:has_been_updated?).twice.returns(true)

      assert_difference "Audit.succeeded.count", +1 do
        with_mocked_fulfillment_service(shop) do
          response = Loader.new(shop.id).call

          assert response.success?
          assert_equal expected_message, response.value
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

    def mock_product_loader(product, times: 1)
      response = Response.success("Product created", product)

      product_loader_mock = mock
      product_loader_mock.expects(:call).times(times).returns(response)

      Product::Loader.expects(:new).times(times).returns(product_loader_mock)
    end

    def mock_product_fulfillment_service(external_id, available, product)
      fulfillment_service_mock = mock
      fulfillment_service_mock
        .expects(:set_inventory_level)
        .with(external_id, available)
        .returns(Response.success(product))

      ::V1::Product.any_instance.stubs(:fulfillment_service).returns(fulfillment_service_mock)
    end

    def stub_fulfillment_service_catalog_request
      stub_request(:get, "https://distribudiet.net/catalogo/archivos/PRESTA_C_lB6W_2_art_total.csv")
        .with(body: {})
        .to_return(
          status: 200,
          body: File.read(file_fixture("raw_catalog.csv")),
          headers: {}
        )
    end

    def stub_download_image
      fixture_picture = File.read(file_fixture("01003.jpg"))

      stub_request(:get, "http://mystring/")
        .to_return(status: 200, body: fixture_picture, headers: {})
    end

    def expected_audit_message(product_id)
      "V1::Product##{product_id} loaded successfully"
    end
  end
end
