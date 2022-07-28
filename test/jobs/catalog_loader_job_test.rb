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

  test "success when repeat and exists available process_id" do
    process_id = SecureRandom.hex(12)
    repeat_at = Time.zone.now
    next_scheduled_at = repeat_at + 1.minute
    shop = create(:shop)
    create(:catalog_loader_scheduler,
           shop: shop, process_id: process_id, next_scheduled_at: repeat_at)
    product_ids = [1003]
    job_params = {
      repeat: true,
      repeat_at: repeat_at,
      process_id: process_id,
      product_ids: product_ids,
      shop_domain: shop.shopify_domain
    }

    loader_response = :ok
    loader_mock = mock
    loader_mock.expects(:call).returns(Response.success(loader_response))
    CatalogLoaderScheduler.any_instance.stubs(:next_scheduled_at).returns(next_scheduled_at)

    Catalog::Loader
      .expects(:new)
      .with(CatalogLoaderJob::LOCAL_PATH, shop.id, product_ids)
      .returns(loader_mock)

    assert_enqueued_with job: ::CatalogLoaderJob,
                         args: [job_params.merge(repeat_at: next_scheduled_at)],
                         queue: "default" do
      response = CatalogLoaderJob.new.perform(**job_params)

      assert response.success?
      assert_equal loader_response, response.value
    end
  end

  test "success when repeat and does not exist available process_id" do
    process_id = SecureRandom.hex(12)
    new_process_id = SecureRandom.hex(12)
    repeat_at = Time.zone.now
    next_scheduled_at = repeat_at + 1.minute
    shop = create(:shop)
    create(:catalog_loader_scheduler,
           shop: shop, process_id: new_process_id, next_scheduled_at: repeat_at)
    product_ids = [1003]
    job_params = {
      repeat: true,
      repeat_at: repeat_at,
      process_id: process_id,
      product_ids: product_ids,
      shop_domain: shop.shopify_domain
    }

    loader_response = :ok
    loader_mock = mock
    loader_mock.expects(:call).returns(Response.success(loader_response))
    CatalogLoaderScheduler.any_instance.stubs(:next_scheduled_at).returns(next_scheduled_at)

    Catalog::Loader
      .expects(:new)
      .with(CatalogLoaderJob::LOCAL_PATH, shop.id, product_ids)
      .returns(loader_mock)

    assert_no_enqueued_jobs only: ::CatalogLoaderJob do
      response = CatalogLoaderJob.new.perform(**job_params)

      assert response.success?
      assert_equal loader_response, response.value
    end
  end
end
