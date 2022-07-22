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

      with_offline_shopify_session(shop) do |session|
        stub_get_product(session)
        stub_update_request(shop)

        product = Product.new(shop_id: shop.id, **update_attributes)
        response = product.save_with_response

        assert response.success?
        assert_kind_of Product, response.value
      end
    end

    private

    def api_version
      ShopifyApp.configuration.api_version
    end

    def stub_create_request(shop)
      url = "https://#{shop.shopify_domain}/admin/api/#{api_version}/products.json"
      params = { Product.new.resource_key => create_params }

      stub_request(:post, url)
        .with(body: params)
        .to_return(
          status: 201,
          body: { product: create_params }.to_json,
          headers: {}
        )
    end

    def product_id
      7_730_938_544_374
    end

    def variant_id
      12_345
    end

    def stub_get_product(session)
      product = ShopifyAPI::Product.new(session: session)
      variant = ShopifyAPI::Variant.new(session: session)
      product.id = product_id
      variant.id = variant_id
      product.variants = [variant]

      ::ShopifyAPI::Product
        .expects(:find)
        .with(session: session, id: product_id)
        .returns(product)
    end

    def stub_update_request(shop)
      url = "https://#{shop.shopify_domain}/admin/api/#{api_version}/products/#{product_id}.json"
      params = { Product.new.resource_key => update_params }

      stub_request(:put, url)
        .with(body: params)
        .to_return(
          status: 200,
          body: { product: update_params }.to_json,
          headers: {}
        )
    end

    def create_attributes
      {
        title: "Burton Custom Freestyle 151",
        body_html: "<h1>Body</h1>",
        vendor: "Burton",
        product_type: "Snowboard table",
        variants: [{ price: 15.30 }],
        images: [{ src: "dummy-img.png" }]
      }
    end

    def update_attributes
      {
        id: product_id,
        title: "Burton Custom Freestyle 151 EDITED",
        body_html: "<h1>Body</h1>",
        vendor: "Burton",
        product_type: "Snowboard table",
        variants: [{ price: 15.30 }],
        images: [{ src: "dummy-img.png" }]
      }
    end

    def create_params
      {
        "title" => "Burton Custom Freestyle 151",
        "body_html" => "<h1>Body</h1>",
        "vendor" => "Burton",
        "product_type" => "Snowboard table",
        "handle" => nil,
        "status" => nil,
        "tags" => nil,
        "images" => [
          {
            "position" => nil,
            "alt" => nil,
            "src" => "dummy-img.png"
          }
        ],
        "variants" => [
          {
            "id" => nil,
            "price" => "15.3",
            "sku" => nil,
            "barcode" => nil,
            "weight" => nil,
            "weight_unit" => nil,
            "taxable" => nil,
            "fulfillment_service" => nil,
            "inventory_policy" => nil,
            "inventory_quantity" => nil,
            "inventory_item_id" => nil,
            "inventory_management" => nil,
            "requires_shipping" => nil
          }
        ]
      }
    end

    def update_params
      {
        "title" => "Burton Custom Freestyle 151 EDITED",
        "body_html" => "<h1>Body</h1>",
        "vendor" => "Burton",
        "product_type" => "Snowboard table",
        "handle" => nil,
        "status" => nil,
        "tags" => nil,
        "images" => [
          {
            "position" => nil,
            "alt" => nil,
            "src" => "dummy-img.png"
          }
        ],
        "variants" => [
          {
            "id" => variant_id.to_s,
            "price" => "15.3",
            "sku" => nil,
            "barcode" => nil,
            "weight" => nil,
            "weight_unit" => nil,
            "taxable" => nil,
            "fulfillment_service" => nil,
            "inventory_policy" => nil,
            "inventory_quantity" => nil,
            "inventory_management" => nil,
            "inventory_item_id" => nil,
            "requires_shipping" => nil
          }
        ]
      }
    end
  end
end
