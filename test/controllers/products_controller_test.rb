# frozen_string_literal: true

require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "success" do
    shop = create(:shop)

    with_shopify_session(shop) do
      mock_get_products
      get products_path, params: {}

      assert_response :ok
      assert_equal products, response.parsed_body["products"]
    end
  end

  private

  def products
    [
      {
        "title" => "Burton Custom Freestyle 151",
        "body_html" => "<h1>Body</h1>",
        "vendor" => "Burton",
        "product_type" => "Snowboard table",
        "variants" => [{ "price" => 15.30 }],
        "images" => [{ "src" => "dummy-img.png" }]
      }
    ]
  end

  def mock_get_products
    ::ShopifyAPI::Product
      .expects(:all).with(limit: 10).returns(products)
  end
end
