# frozen_string_literal: true

require "test_helper"

class FetchStockControllerTest < ActionDispatch::IntegrationTest
  test "fetch empty stock" do
    shop = create(:shop)
    params = { shop: shop.shopify_domain }
    job_params = { shop_domain: params[:shop], skus: [] }

    fetch_stock_mock = mock
    fetch_stock_mock.expects(:call).returns(Response.success({}))
    Shopify::FetchStock.expects(:new).with(params.stringify_keys).returns(fetch_stock_mock)

    assert_enqueued_with job: ::RefreshStockJob, args: [job_params], queue: "default" do
      get fetch_stock_path(**params)

      assert_response :ok
      assert_empty response.parsed_body
    end
  end

  test "fetch stock" do
    shop = create(:shop)
    product = create(:v1_product, sku: 1234, shop: shop)
    expected_response = Response.success(product.sku => product.disponible)
    params = { shop: shop.shopify_domain, sku: "4321" }
    job_params = { shop_domain: params[:shop], skus: params[:sku] }

    fetch_stock_mock = mock
    fetch_stock_mock.expects(:call).returns(expected_response)
    Shopify::FetchStock.expects(:new).with(params.stringify_keys).returns(fetch_stock_mock)

    assert_enqueued_with job: ::RefreshStockJob, args: [job_params], queue: "default" do
      get fetch_stock_path(**params)

      assert_response :ok
      assert_equal expected_response.value, response.parsed_body
    end
  end
end
