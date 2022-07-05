# frozen_string_literal: true

require "test_helper"

class AuditsControllerTest < ActionDispatch::IntegrationTest
  test "success" do
    audit = create(:audit)

    with_shopify_session(audit.shop) do
      get audits_path, params: {}

      assert_response :ok
      assert_template :index
      assert_includes @controller.view_assigns["audits"], audit
    end
  end

  test "success filtering by shop" do
    shop = create(:shop, shopify_domain: "test-2.shopify.shop")
    audit_one = create(:audit)
    audit_two = create(:audit, shop_domain: audit_one.shop.shopify_domain)
    audit_three = create(:audit, shop_domain: shop.shopify_domain)

    with_shopify_session(audit_one.shop) do
      get audits_path, params: {}

      assert_response :ok
      assert_template :index
      assert_includes @controller.view_assigns["audits"], audit_one
      assert_includes @controller.view_assigns["audits"], audit_two
      assert_not_includes @controller.view_assigns["audits"], audit_three
    end
  end

  test "success with pagination" do
    audit_one = create(:audit)
    audit_two = create(:audit, shop_domain: audit_one.shop.shopify_domain)

    with_shopify_session(audit_one.shop) do
      get audits_path, params: { page: 1, per_page: 1 }

      assert_response :ok
      assert_template :index
      assert_includes @controller.view_assigns["audits"], audit_two
      assert_not_includes @controller.view_assigns["audits"], audit_one
    end
  end
end
