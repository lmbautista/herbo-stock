# frozen_string_literal: true

require "test_helper"

module Shopify
  module Webhooks
    class FulfillmentCreatedControllerTest < ActionDispatch::IntegrationTest
      test "enqueue job successfully" do
        job_params = {
          shop_domain: product.shop.shopify_domain,
          product_ids: [product.id]
        }

        assert_enqueued_with job: CatalogLoaderJob,
                             args: [job_params],
                             queue: "default" do
          headers = { "HTTP_X_SHOPIFY_SHOP_DOMAIN" => product.shop.shopify_domain }

          post shopify_webhooks_fulfillment_created_path, params: webhook_params, headers: headers

          assert_response :ok
        end
      end

      private

      def product_external_id
        "7737644253430"
      end

      def product
        return @product if defined?(@product)

        @product = create(:v1_product)
        create(:v1_product_external_resource, product: @product, external_id: product_external_id)

        @product
      end

      def webhook_params
        {
          "id" => 4_355_407_020_278,
          "order_id" => 4_862_885_560_566,
          "status" => "success",
          "created_at" => "2022-07-23T14:07:31+02:00",
          "service" => "distribudiet-fulfillment",
          "updated_at" => "2022-07-23T14:07:31+02:00",
          "tracking_company" => "SEUR",
          "shipment_status" => nil,
          "location_id" => 70_277_726_454,
          "origin_address" => nil,
          "email" => "lmiguelbautista@gmail.com",
          "destination" => { "first_name" => "Luis Miguel",
                             "address1" => "Calle de Francia 45",
                             "phone" => nil,
                             "city" => "Fuenlabrada",
                             "zip" => "28941",
                             "province" => "Madrid",
                             "country" => "Spain",
                             "last_name" => "Bautista Fraile",
                             "address2" => "",
                             "company" => nil,
                             "latitude" => 31.2844418,
                             "longitude" => -3.3337866,
                             "name" => "Luis Miguel Bautista Fraile",
                             "country_code" => "ES",
                             "province_code" => "M" },
          "line_items" => [{ "id" => 12_385_068_515_574,
                             "variant_id" => 44_159_861_915_894,
                             "title" => "Copos de avena 1000gr",
                             "quantity" => 5,
                             "sku" => "01003",
                             "variant_title" => "",
                             "vendor" => "Granovita",
                             "fulfillment_service" => "distribudiet-fulfillment",
                             "product_id" => product.external_id,
                             "requires_shipping" => true,
                             "taxable" => true,
                             "gift_card" => false,
                             "name" => "Copos de avena 1000gr",
                             "variant_inventory_management" => "distribudiet-fulfillment",
                             "properties" => [],
                             "product_exists" => true,
                             "fulfillable_quantity" => 0,
                             "grams" => 1000,
                             "price" => "3.14",
                             "total_discount" => "0.00",
                             "fulfillment_status" => "fulfilled",
                             "price_set" => {
                               "shop_money" => {
                                 "amount" => "3.14",
                                 "currency_code" => "EUR"
                               },
                               "presentment_money" => {
                                 "amount" => "3.14",
                                 "currency_code" => "EUR"
                               }
                             },
                             "total_discount_set" => {
                               "shop_money" => {
                                 "amount" => "0.00",
                                 "currency_code" => "EUR"
                               },
                               "presentment_money" => {
                                 "amount" => "0.00",
                                 "currency_code" => "EUR"
                               }
                             },
                             "discount_allocations" => [],
                             "duties" => [],
                             "admin_graphql_api_id" => "gid://shopify/LineItem/12385068515574",
                             "tax_lines" => [] }]
        }
      end
    end
  end
end
