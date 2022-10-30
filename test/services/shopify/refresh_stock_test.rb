# frozen_string_literal: true

require "test_helper"

module Shopify
  class RefreshStockTest < ActiveSupport::TestCase
    test "has audit" do
      assert_includes RefreshStock.included_modules, WithAudit
    end

    test "success with filtered product ids" do
      shop = create(:shop)
      stub_fulfillment_service_catalog_request

      response = RefreshStock.new(shop_domain: shop.shopify_domain, skus: ["xxx"]).call

      assert response.success?
      assert_empty response.value
    end

    test "success" do
      shop = create(:shop)
      product = create(:v1_product, shop: shop, sku: "8888")
      external_id = create(:v1_product_external_resource, product: product).external_id
      expected_success_message = "Inventory set successfully for product with SKU #{product.sku}"

      mock_product_fulfillment_service(external_id, product.disponible)
      stub_fulfillment_service_catalog_request

      response = RefreshStock.new(shop_domain: shop.shopify_domain, skus: [product.sku]).call

      assert response.success?
      assert_includes response.value, expected_success_message
    end

    test "fails when product does not exists" do
      expected_error_message = "Product with SKU 8888 not found"
      shop = create(:shop)
      stub_fulfillment_service_catalog_request

      response = RefreshStock.new(shop_domain: shop.shopify_domain, skus: ["8888"]).call

      assert response.success?
      assert_includes response.value, expected_error_message
    end

    private

    def mock_product_fulfillment_service(external_id, _available)
      fulfillment_service_mock = mock
      fulfillment_service_mock
        .expects(:set_inventory_level)
        .with(external_id, 24)
        .returns(Response.success("Inventory set successfully"))

      ::V1::Product.any_instance.stubs(:fulfillment_service).returns(fulfillment_service_mock)
    end

    def stub_fulfillment_service_catalog_request
      stub_request(:get, "https://distribudiet.net/catalogo/archivos/PRESTA_C_5Yep7Q_stock.csv")
        .with(body: {})
        .to_return(
          status: 200,
          body: File.read(file_fixture("refresh_stock.csv")),
          headers: {}
        )
    end
  end
end
