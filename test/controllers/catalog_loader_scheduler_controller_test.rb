# frozen_string_literal: true

require "test_helper"

class CatalogLoaderSchedulerControllerTest < ActionDispatch::IntegrationTest
  test "new success without catalog loader scheduler" do
    shop = create(:shop)

    with_shopify_session(shop) do
      get catalog_loader_scheduler_path

      assert_response :ok
      assert_template :new
      assert_nil @controller.view_assigns["catalog_loader_scheduler"]
    end
  end

  test "new success with catalog loader scheduler" do
    catalog_loader_scheduler = create(:catalog_loader_scheduler, :scheduled)

    with_shopify_session(catalog_loader_scheduler.shop) do
      get catalog_loader_scheduler_path

      assert_response :ok
      assert_template :new
      assert_equal @controller.view_assigns["catalog_loader_scheduler"], catalog_loader_scheduler
    end
  end

  test "create success" do
    shop = create(:shop)
    params = { time_unit: "hours", time_amount: "24" }
    loader_params = params.values.push(shop.shopify_domain)
    loader_response = Response.success(:ok)
    expected_response = { message: loader_response.value }.as_json

    with_shopify_session(shop) do
      mock_catalog_scheduled_loader(loader_response, loader_params)
      post catalog_loader_scheduler_path, params: { catalog_loader_scheduler: params }

      assert_response :ok
      assert_equal expected_response, response.parsed_body
    end
  end

  test "create fails" do
    shop = create(:shop)
    params = { time_unit: "hours", time_amount: "24" }
    loader_params = params.values.push(shop.shopify_domain)
    loader_response = Response.failure(:ko)
    expected_response = { message: loader_response.value }.as_json

    with_shopify_session(shop) do
      mock_catalog_scheduled_loader(loader_response, loader_params)
      post catalog_loader_scheduler_path, params: { catalog_loader_scheduler: params }

      assert_response :ok
      assert_equal expected_response, response.parsed_body
    end
  end

  private

  def mock_catalog_scheduled_loader(response, params)
    scheduler_loader_mock = mock
    scheduler_loader_mock.expects(:call).returns(response)

    ::Catalog::ScheduledLoader.expects(:new).with(*params).returns(scheduler_loader_mock)
  end
end
