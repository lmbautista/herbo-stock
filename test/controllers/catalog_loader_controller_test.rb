# frozen_string_literal: true

require "test_helper"

class CatalogLoaderControllerTest < ActionDispatch::IntegrationTest
  test "success" do
    job_params = {
      product_ids: product_ids,
      shop_domain: shop.shopify_domain
    }.stringify_keys

    with_shopify_session(shop) do
      assert_enqueued_with job: ::CatalogLoaderJob,
                           args: [job_params],
                           queue: "default" do
        post catalog_loader_path(params: create_params)
      end
    end
  end

  private

  def shop
    @shop ||= create(:shop)
  end

  def product_ids
    ["1003"]
  end

  def create_params
    { catalog_loader: { product_ids: product_ids } }
  end
end
