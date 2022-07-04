# frozen_string_literal: true

require "test_helper"

class CatalogLoaderJobTest < ActiveJob::TestCase
  test "success" do
    shop = create(:shop)
    product_ids = [1003]

    job_params = {
      product_ids: product_ids,
      shop_domain: shop.shopify_domain
    }

    loader_mock = mock
    loader_mock.expects(:call).returns(Response.success(:ok))

    Catalog::Loader
      .expects(:new)
      .with(CatalogLoaderJob::LOCAL_PATH, shop.id, product_ids)
      .returns(loader_mock)

    CatalogLoaderJob.new.perform(**job_params)
  end
end
