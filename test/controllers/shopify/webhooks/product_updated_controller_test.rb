# frozen_string_literal: true

require "test_helper"

module Shopify
  module Webhooks
    class ProductUpdatedControllerTest < ActionDispatch::IntegrationTest
      test "enqueue job successfully" do
        job_params = {
          topic: "products/update",
          shop_domain: product.shop.shopify_domain,
          body: webhook_params
        }

        assert_enqueued_with job: Shopify::Webhooks::ProductsUpdateJob,
                             args: [job_params],
                             queue: "default" do
          params = { product_updated: webhook_params }
          headers = { "HTTP_X_SHOPIFY_SHOP_DOMAIN" => product.shop.shopify_domain }
          post shopify_webhooks_product_updated_path, params: params, headers: headers

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
          "admin_graphql_api_id" => "gid://shopify/Product/7737644253430",
          "body_html" => "<h1>Body HTML</h1>",
          "created_at" => "2022-06-27T08:19:18+02:00",
          "handle" => "aceite-oliva-virgen-extra-500ml",
          "id" => product_external_id,
          "image" => {
            "admin_graphql_api_id" => "gid://shopify/ProductImage/37312550994166",
            "alt" => "",
            "created_at" => "2022-06-27T08:45:32+02:00",
            "height" => "650",
            "id" => "37312550994166",
            "position" => "1",
            "product_id" => "7737644253430",
            "src" => "https://cdn.shopify.com/s/files/1/0649/7520/8694/products/01078.jpg?v=1656312332",
            "updated_at" => "2022-06-27T08:45:32+02:00",
            "variant_ids" => [""],
            "width" => "400"
          },
          "images" => [
            {
              "admin_graphql_api_id" => "gid://shopify/ProductImage/37312550994166",
              "alt" => "",
              "created_at" => "2022-06-27T08:45:32+02:00",
              "height" => "650",
              "id" => "37312550994166",
              "position" => "1",
              "product_id" => "7737644253430",
              "src" => "https://cdn.shopify.com/s/files/1/0649/7520/8694/products/01078.jpg?v=1656312332",
              "updated_at" => "2022-06-27T08:45:32+02:00",
              "variant_ids" => [""],
              "width" => "400"
            }
          ],
          "options" => [
            {
              "id" => "9825645986038",
              "name" => "Title",
              "position" => "1",
              "product_id" => "7737644253430",
              "values" => [
                "Default Title"
              ]
            }
          ],
          "product_type" => "Aceites y condimentos",
          "published_at" => "2022-06-27T08:19:18+02:00",
          "published_scope" => "web",
          "status" => "active",
          "tags" => "Aceites",
          "template_suffix" => "",
          "title" => "Aceite oliva virgen extra 500ml",
          "updated_at" => "2022-06-30T16:07:26+02:00",
          "variants" => [
            {
              "admin_graphql_api_id" => "gid://shopify/ProductVariant/44031645090038",
              "barcode" => "8423266091001",
              "compare_at_price" => "",
              "created_at" => "2022-06-27T08:45:32+02:00",
              "fulfillment_service" => "manual",
              "grams" => "500",
              "id" => "44031645090038",
              "image_id" => "",
              "inventory_item_id" => "45350008783094",
              "inventory_management" => "shopify",
              "inventory_policy" => "deny",
              "inventory_quantity" => "3",
              "old_inventory_quantity" => "3",
              "option1" => "Default Title",
              "option2" => "",
              "option3" => "",
              "position" => "1",
              "price" => "6.94",
              "product_id" => "7737644253430",
              "requires_shipping" => "true",
              "sku" => "01078",
              "taxable" => "true",
              "title" => "Default Title",
              "updated_at" => "2022-06-27T08:45:32+02:00",
              "weight" => "500",
              "weight_unit" => "g"
            }
          ],
          "vendor" => "Granovita"
        }
      end
    end
  end
end
