# frozen_string_literal: true

require "test_helper"

module Shopify
  class ProductTest < ActiveSupport::TestCase
    test "#resource_key" do
      assert_equal "product", Product.new.resource_key
    end

    test "create success" do
      shop = create(:shop)
      stub_create_request(shop)

      product = Product.new(shop_id: shop.id, **create_attributes)
      response = product.save_with_response

      assert response.success?
      assert_kind_of Product, response.value
    end

    test "update success" do
      shop = create(:shop)
      stub_update_request(shop)

      product = Product.new(shop_id: shop.id, **update_attributes)
      response = product.save_with_response

      assert response.success?
      assert_kind_of Product, response.value
    end

    private

    def api_version
      ShopifyApp.configuration.api_version
    end

    def stub_create_request(shop)
      url = "https://#{shop.shopify_domain}/admin/api/#{api_version}/products.json"
      params = { Product.new.resource_key => create_attributes }

      stub_request(:post, url)
        .with(body: params)
        .to_return(
          status: 201,
          body: { product: create_attributes.merge(id: product_id) }.to_json,
          headers: {}
        )
    end

    def product_id
      7_730_938_544_374
    end

    def stub_update_request(shop)
      url = "https://#{shop.shopify_domain}/admin/api/#{api_version}/products/#{product_id}.json"
      params = { Product.new.resource_key => update_attributes }

      stub_request(:put, url)
        .with(body: params)
        .to_return(
          status: 200,
          body: { product: update_attributes }.to_json,
          headers: {}
        )
    end

    def create_attributes
      {
        title: "Burton Custom Freestyle 151",
        body_html: "<h1>Body</h1>",
        vendor: "Burton",
        product_type: "Snowboard table"
      }
    end

    def update_attributes
      {
        id: product_id,
        title: "Burton Custom Freestyle 151 EDITED",
        body_html: "<h1>Body</h1>",
        vendor: "Burton",
        product_type: "Snowboard table"
      }
    end
  end
end
