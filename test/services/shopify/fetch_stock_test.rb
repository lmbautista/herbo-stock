# frozen_string_literal: true

require "test_helper"

module Shopify
  class FetchStockTest < ActiveSupport::TestCase
    test "with audit" do
      assert_includes FetchStock.included_modules, WithAudit
    end

    test "fetch empty stock when shop is not provided" do
      response = FetchStock.new({}).call
      expected_value = "Products not found"

      assert response.success?
      assert_empty response.resource
      assert_equal expected_value, response.value
    end

    test "fetch empty stock when shop is empty" do
      shop = create(:shop)
      response = FetchStock.new(shop: shop.shopify_domain).call
      expected_value = "Products not found"

      assert response.success?
      assert_empty response.resource
      assert_equal expected_value, response.value
    end

    test "fetch empty stock when product does not exist by sku" do
      shop = create(:shop)
      create(:v1_product, sku: 1234, shop: shop)
      expected_value = "Products not found"

      response = FetchStock.new(shop: shop.shopify_domain, sku: 4321).call

      assert response.success?
      assert_empty response.resource
      assert_equal expected_value, response.value
    end

    test "fetch stock when product exists by sku" do
      shop = create(:shop)
      product = create(:v1_product, sku: 1234, shop: shop)
      expected_value = "Stock for products with SKU #{product.sku} will be updated in Shopify"
      expected_resource = { product.sku => product.disponible }

      response = FetchStock.new(shop: shop.shopify_domain, sku: product.sku).call

      assert response.success?
      assert_equal expected_value, response.value
      assert_equal expected_resource, response.resource
    end

    test "fetch all stock when we do not filter by sku" do
      shop = create(:shop)
      product_one = create(:v1_product, id: 1, sku: 1234, shop: shop)
      product_two = create(:v1_product, id: 2, sku: 1235, shop: shop)

      expected_value = "Stock for products with SKU " \
                       "#{[product_one, product_two].map(&:sku).to_sentence} will be updated " \
                       "in Shopify"
      expected_resource = {
        product_one.sku => product_one.disponible,
        product_two.sku => product_two.disponible
      }

      response = FetchStock.new(shop: shop.shopify_domain).call

      assert response.success?
      assert_equal expected_value, response.value
      assert_equal expected_resource, response.resource
    end
  end
end
