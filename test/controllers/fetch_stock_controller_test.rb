# frozen_string_literal: true

require "test_helper"

class FetchStockControllerTest < ActionDispatch::IntegrationTest
  test "fetch empty stock" do
    fetch_stock_mock = mock
    fetch_stock_mock.expects(:call).returns(Response.success({}))
    Shopify::FetchStock.expects(:new).with({}).returns(fetch_stock_mock)

    get fetch_stock_path

    assert_response :ok
    assert_empty response.parsed_body
  end

  test "fetch stock" do
    shop = create(:shop)
    product = create(:v1_product, sku: 1234, shop: shop)
    expected_response = Response.success(product.sku => product.disponible)
    params = { shop: shop.shopify_domain, sku: "4321" }

    fetch_stock_mock = mock
    fetch_stock_mock.expects(:call).returns(expected_response)
    Shopify::FetchStock.expects(:new).with(params.stringify_keys).returns(fetch_stock_mock)

    get fetch_stock_path(**params)

    assert_response :ok
    assert_equal expected_response.value, response.parsed_body
  end
end
