# frozen_string_literal: true

require "test_helper"

module Shopify
  module Webhooks
    class ProductsUpdateJobTest < ActiveJob::TestCase
      test "with audit" do
        assert_includes ProductsUpdateJob.included_modules, WithAudit
      end

      test "#handle" do
        job_params = {
          topic: "products/update",
          shop_domain: product.shop.shopify_domain,
          body: webhook_params
        }

        assert_enqueued_with job: ProductsUpdateJob, args: [job_params], queue: "default" do
          ProductsUpdateJob.handle(**job_params)
        end
      end

      test "webhook succeeded" do
        job_params = {
          topic: "products/update",
          shop_domain: product.shop.shopify_domain,
          body: webhook_params
        }

        assert_difference "V1::Webhook.succeeded.count", +1 do
          assert_changes -> { product.reload.disponible },
                         from: original_inventory_quantity, to: updated_inventory_quantity do
            ProductsUpdateJob.new.perform(**job_params)
          end
        end
      end

      test "webhook succeeded when product does not exists" do
        job_params = {
          topic: "products/update",
          shop_domain: product.shop.shopify_domain,
          body: webhook_params("id" => 7_737_644_253_555)
        }

        assert_no_difference "V1::Webhook.succeeded.count" do
          assert_no_changes -> { product.reload.disponible } do
            ProductsUpdateJob.new.perform(**job_params)
          end
        end
      end

      test "webhook succeeded when inventory_quantity is nil" do
        job_params = {
          topic: "products/update",
          shop_domain: product.shop.shopify_domain,
          body: webhook_params("variants" => [])
        }

        assert_no_difference "V1::Webhook.succeeded.count" do
          assert_no_changes -> { product.reload.disponible } do
            ProductsUpdateJob.new.perform(**job_params)
          end
        end
      end

      test "webhook failed" do
        job_params = {
          topic: "products/update",
          shop_domain: product.shop.shopify_domain,
          body: webhook_params
        }

        ar_errors = mock
        ar_errors.expects(:full_messages).returns(Array.wrap("whatever goes wrong"))

        ::V1::Product.any_instance.stubs(:update).returns(false)
        ::V1::Product.any_instance.stubs(:errors).returns(ar_errors)

        assert_difference "V1::Webhook.failed.count", +1 do
          assert_no_changes product do
            ProductsUpdateJob.new.perform(**job_params)
          end
        end
      end

      private

      def product_external_id
        7_737_644_253_430
      end

      def product
        return @product if defined?(@product)

        @product = create(:v1_product)
        create(:v1_product_external_resource, product: @product, external_id: product_external_id)

        @product
      end

      def original_inventory_quantity
        1
      end

      def updated_inventory_quantity
        0
      end

      def webhook_params(overriden_params = {})
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
            "variant_ids" => [],
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
              "variant_ids" => [],
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
              "inventory_quantity" => "0",
              "old_inventory_quantity" => "0",
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
        }.deep_merge(overriden_params)
      end
    end
  end
end
