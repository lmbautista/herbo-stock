# frozen_string_literal: true

require "test_helper"

class ArchiveStockJobTest < ActiveJob::TestCase
  test "success" do
    shop = create(:shop)

    job_params = { shop_domain: shop.shopify_domain }

    archiver_mock = mock
    archiver_mock.expects(:call).returns(Response.success(:ok))

    Shopify::ArchiveStock
      .expects(:new)
      .with(*job_params.values)
      .returns(archiver_mock)

    assert_enqueued_with job: ::ArchiveStockJob,
                         args: [job_params],
                         queue: "default" do
      ArchiveStockJob.new.perform(**job_params)
    end
  end
end
