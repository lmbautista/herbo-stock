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

          stub_create_fulfillment_service

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

      private

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
          "location_id" => 70_191_939_830,
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
