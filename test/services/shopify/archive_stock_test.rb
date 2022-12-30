# frozen_string_literal: true

require "test_helper"

module Shopify
  class ArchiveStockTest < ActiveSupport::TestCase
    include FulfillmentServiceHelper

    teardown do
      File.delete("public/MyString") if File.exist?("public/MyString")
    end

    test "has audit" do
      assert_includes ArchiveStock.included_modules, WithAudit
    end

    test "success with filtered product ids" do
      shop = create(:shop)
      stub_fulfillment_service_catalog_request
      stub_fulfillment_service_stock_request

      assert_no_difference -> { ::V1::Product.where(disponible: 0).count } do
        response = ArchiveStock.new(shop.shopify_domain).call

        assert response.success?
        assert_empty response.value
      end
    end

    test "success" do
      shop = create(:shop)
      product_one = create(:v1_product, shop: shop, sku: "01003")
      create(:v1_product, shop: shop, sku: "8888")
      product_three = create(:v1_product, shop: shop, sku: "01004")
      external_id = create(:v1_product_external_resource, product: product_three).external_id

      expected_success_message =
        "Inventory set successfully for product with SKU #{product_three.sku}"

      stub_download_image

      expected_shopify_response = Response.success(Shopify::Product.new(id: external_id))
      stub_shopify_product(expected_shopify_response)

      mock_product_fulfillment_service(external_id, 0)
      stub_fulfillment_service_catalog_request
      stub_fulfillment_service_stock_request

      assert_no_changes -> { product_one.reload } do
        assert_difference -> { ::V1::Product.where(disponible: 0).count }, +1 do
          with_mocked_fulfillment_service(shop) do
            response = ArchiveStock.new(shop.shopify_domain).call

            assert response.success?
            assert_includes response.value, expected_success_message
            assert ::V1::Product.exists?(sku: product_three.sku, disponible: 0)
          end
        end
      end
    end

    private

    def mock_product_fulfillment_service(external_id, available)
      fulfillment_service_mock = mock
      fulfillment_service_mock
        .expects(:set_inventory_level)
        .with(external_id, available)
        .returns(Response.success("Inventory set successfully"))

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

    def stub_fulfillment_service_stock_request
      stub_request(:get, "https://distribudiet.net/catalogo/archivos/PRESTA_C_5Yep7Q_stock.csv")
        .with(body: {})
        .to_return(
          status: 200,
          body: File.read(file_fixture("refresh_stock.csv")),
          headers: {}
        )
    end

    def stub_shopify_product(response)
      ::Shopify::Product.any_instance
        .stubs(:save_with_response)
        .returns(response)
    end

    def stub_download_image
      fixture_picture = File.read(file_fixture("01003.jpg"))

      stub_request(:get, "http://mystring/")
        .to_return(status: 200, body: fixture_picture, headers: {})
    end
  end
end
