# frozen_string_literal: true

require "test_helper"

module Shopify
  module FulfillmentServices
    class DistribudietTest < ActiveSupport::TestCase
      test "initialize existing fulfillment service" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do |session|
          fulfillment_services = [build_fulfillment_service(session, fulfillment_service_params)]
          mock_get_fulfillment_services(fulfillment_services)

          fulfillment_service = Distribudiet.new(shop.id)

          assert_equal Distribudiet.const_get(:SERVICE_NAME), fulfillment_service.name
        end
      end

      test "create and initialize unexisting fulfillment service" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do |_session|
          mock_get_fulfillment_services([])
          stub_create_fulfillment_service

          fulfillment_service = Distribudiet.new(shop.id)

          assert_equal Distribudiet.const_get(:SERVICE_NAME), fulfillment_service.name
        end
      end

      test "#set_inventory_level success" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do |session|
          available = 35
          fulfillment_services = [build_fulfillment_service(session, fulfillment_service_params)]
          product = ShopifyAPI::Product.new(session: session)
          variant = ShopifyAPI::Variant.new(session: session)
          variant.inventory_item_id = inventory_item_id
          product.variants = [variant]

          mock_get_fulfillment_services(fulfillment_services)
          mock_get_product(session, product)
          stub_set_inventory_level(available)

          fulfillment_service = Distribudiet.new(shop.id)
          response = fulfillment_service.set_inventory_level(product_id, available)

          assert response.success?
          assert_equal "Inventory set successfully", response.value
        end
      end

      test "#set_inventory_level fails" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do |session|
          expected_error = "{:code=>422}"
          available = 35
          fulfillment_services = [build_fulfillment_service(session, fulfillment_service_params)]
          product = ShopifyAPI::Product.new(session: session)
          variant = ShopifyAPI::Variant.new(session: session)
          variant.inventory_item_id = inventory_item_id
          product.variants = [variant]

          mock_get_fulfillment_services(fulfillment_services)
          mock_get_product(session, product)

          ShopifyAPI::InventoryLevel
            .any_instance
            .stubs(:set)
            .raises(ShopifyAPI::Errors::HttpResponseError.new(code: 422))

          fulfillment_service = Distribudiet.new(shop.id)
          response = fulfillment_service.set_inventory_level(product_id, available)

          assert response.failure?
          assert_equal expected_error, response.value
        end
      end

      test "#set_inventory_level when product has no variant" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do |session|
          available = 35
          product = ShopifyAPI::Product.new(session: session)
          product.variants = []

          mock_get_product(session, product)

          fulfillment_service = Distribudiet.new(shop.id)
          response = fulfillment_service.set_inventory_level(product_id, available)

          assert response.success?
          assert_equal "Variant not found to set inventory level", response.value
        end
      end

      test "#username" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do
          fulfillment_service = Distribudiet.new(shop.id)

          assert fulfillment_service.username
        end
      end

      test "#password" do
        shop = create(:shop)
        with_offline_shopify_session(shop) do
          fulfillment_service = Distribudiet.new(shop.id)

          assert fulfillment_service.password
        end
      end

      test "#get_url_for_source for all_products" do
        expected_url = %r{https://herbomadrid:.+@distribudiet.net/catalogo/archivos/PRESTA_C_lB6W_2_art_total.csv}
        shop = create(:shop)
        with_offline_shopify_session(shop) do
          fulfillment_service = Distribudiet.new(shop.id)

          assert_match expected_url, fulfillment_service.get_url_for_source("all_products")
        end
      end

      test "#get_url_for_source for stock_and_prices" do
        expected_url = %r{https://herbomadrid:.+@distribudiet.net/catalogo/archivos/PRESTA_C_5Yep7Q_stock.csv}
        shop = create(:shop)
        with_offline_shopify_session(shop) do
          fulfillment_service = Distribudiet.new(shop.id)

          assert_match expected_url, fulfillment_service.get_url_for_source("stock_and_prices")
        end
      end

      test "#get_url_for_source for archived_products" do
        expected_url = %r{https://herbomadrid:.+@distribudiet.net/catalogo/archivos/PRESTA_art_baja.csv}
        shop = create(:shop)
        with_offline_shopify_session(shop) do
          fulfillment_service = Distribudiet.new(shop.id)

          assert_match expected_url, fulfillment_service.get_url_for_source("archived_products")
        end
      end

      private

      def product_id
        7_730_938_544_374
      end

      def inventory_item_id
        5_391_312_655_351
      end

      def location_id
        70_191_939_830
      end

      def mock_get_fulfillment_services(fulfillment_services, times = 1)
        ::ShopifyAPI::FulfillmentService
          .expects(:all)
          .times(times)
          .returns(fulfillment_services)
      end

      def stub_create_fulfillment_service
        stub_request(:post, "https://test.shopify.shop/admin/api/2022-04/fulfillment_services.json")
          .with(body: { fulfillment_service: create_params }.to_json)
          .to_return(status: 200, body: "", headers: {})
      end

      def stub_set_inventory_level(available)
        body = {
          location_id: location_id,
          inventory_item_id: inventory_item_id,
          available: available
        }.to_json

        stub_request(:post, %r{test.shopify.shop/admin/api/2022-04/inventory_levels/set.json})
          .with(body: body)
          .to_return(status: 200, body: "", headers: {})
      end

      def mock_get_product(session, product)
        ::ShopifyAPI::Product
          .expects(:find)
          .with(session: session, id: product_id)
          .returns(product)
      end

      def create_params
        {
          "callback_url" => ENV.fetch("HOST", nil),
          "format" => "json",
          "inventory_management" => true,
          "name" => "Distribudiet Fulfillment",
          "requires_shipping_method" => false,
          "tracking_support" => false
        }
      end

      def fulfillment_service_params
        {
          "admin_graphql_api_id" => "gid://shopify/ApiFulfillmentService/61749559542",
          "callback_url" => ENV.fetch("HOST", nil),
          "fulfillment_orders_opt_in" => false,
          "handle" => "distribudiet-fulfillment",
          "id" => 61_749_559_542,
          "inventory_management" => true,
          "location_id" => location_id,
          "name" => "Distribudiet Fulfillment",
          "provider_id" => nil,
          "tracking_support" => false,
          "email" => nil,
          "service_name" => "Distribudiet Fulfillment",
          "include_pending_stock" => false
        }
      end

      def build_fulfillment_service(session, params)
        fulfillment_service = ::ShopifyAPI::FulfillmentService.new(session: session)
        fulfillment_service.original_state = params
        params.each { |key, value| fulfillment_service.send("#{key}=", value) }

        fulfillment_service
      end
    end
  end
end
