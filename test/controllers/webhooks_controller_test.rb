# frozen_string_literal: true

require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "success" do
    webhook = create(:v1_webhook)

    with_shopify_session(webhook.shop) do
      mock_get_webhooks
      get webhooks_path, params: {}

      assert_response :ok
      assert_template :index
      assert_includes @controller.view_assigns["webhooks"], webhook
      assert_not_includes @controller.view_assigns["webhooks_configuration"], webhooks
    end
  end

  test "success filtering by shop" do
    shop = create(:shop, shopify_domain: "test-2.shopify.shop")
    webhook_one = create(:v1_webhook)
    webhook_two = create(:v1_webhook, shop_domain: webhook_one.shop.shopify_domain)
    webhook_three = create(:v1_webhook, shop_domain: shop.shopify_domain)

    with_shopify_session(webhook_one.shop) do
      mock_get_webhooks
      get webhooks_path, params: {}

      assert_response :ok
      assert_template :index
      assert_includes @controller.view_assigns["webhooks"], webhook_one
      assert_includes @controller.view_assigns["webhooks"], webhook_two
      assert_not_includes @controller.view_assigns["webhooks"], webhook_three
      assert_not_includes @controller.view_assigns["webhooks_configuration"], webhooks
    end
  end

  test "success with pagination" do
    webhook_one = create(:v1_webhook)
    webhook_two = create(:v1_webhook, shop_domain: webhook_one.shop.shopify_domain)

    with_shopify_session(webhook_one.shop) do
      mock_get_webhooks
      get webhooks_path, params: { page: 1, per_page: 1 }

      assert_response :ok
      assert_template :index
      assert_includes @controller.view_assigns["webhooks"], webhook_one
      assert_not_includes @controller.view_assigns["webhooks"], webhook_two
      assert_not_includes @controller.view_assigns["webhooks_configuration"], webhooks
    end
  end

  private

  def mock_get_webhooks
    ::ShopifyAPI::Webhook
      .expects(:all).with(limit: 10).returns(webhooks)
  end

  def webhooks
    @webhooks ||= webhooks_config.map { ShopifyWebhook.new _1 }
  end

  def webhooks_config
    [
      { topic: "app/uninstalled", address: "http://app_uninstalled.com" },
      { topic: "products/create", address: "http://product_created.com" }
    ]
  end

  ShopifyWebhook = Struct.new(:topic, :address)
  private_constant :ShopifyWebhook
end
