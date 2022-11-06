# frozen_string_literal: true

require "test_helper"

class RefreshStockJobTest < ActiveJob::TestCase
  test "success" do
    shop = create(:shop)
    product = create(:v1_product, shop: shop)
    skus = [product.sku]

    job_params = {
      shop_domain: shop.shopify_domain,
      skus: skus
    }

    refresher_mock = mock
    refresher_mock.expects(:call).returns(Response.success(:ok))

    Shopify::RefreshStock
      .expects(:new)
      .with(*job_params.values)
      .returns(refresher_mock)

    RefreshStockJob.new.perform(**job_params)
  end
end
