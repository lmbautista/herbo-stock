# frozen_string_literal: true

require "test_helper"

class FetchStockControllerTest < ActionDispatch::IntegrationTest
  test "fetch empty stock when shop is not provided" do
    get fetch_stock_path

    assert_response :ok
    assert_empty response.parsed_body
  end

  test "fetch empty stock when shop is empty" do
    shop = create(:shop)
    get fetch_stock_path(shop: shop.shopify_domain)

    assert_response :ok
    assert_empty response.parsed_body
  end

  test "fetch empty stock when product does not exist by sku" do
    shop = create(:shop)
    create(:v1_product, sku: 1234, shop: shop)

    get fetch_stock_path(shop: shop.shopify_domain, sku: 4321)

    assert_response :ok
    assert_empty response.parsed_body
  end

  test "fetch stock when product exists by sku" do
    shop = create(:shop)
    product = create(:v1_product, sku: 1234, shop: shop)
    expected_body = { product.sku => product.disponible }

    get fetch_stock_path(shop: shop.shopify_domain, sku: product.sku)

    assert_equal expected_body, response.parsed_body
  end

  test "fetch all stock when we do not filter by sku" do
    shop = create(:shop)
    product_one = create(:v1_product, id: 1, sku: 1234, shop: shop)
    product_two = create(:v1_product, id: 2, sku: 1235, shop: shop)
    expected_body = {
      product_one.sku => product_one.disponible,
      product_two.sku => product_two.disponible
    }

    get fetch_stock_path(shop: shop.shopify_domain)

    assert_equal expected_body, response.parsed_body
  end
end
