# frozen_string_literal: true

require "test_helper"

class ShopTest < ActiveSupport::TestCase
  test "#api_version" do
    shop = build_stubbed(:shop)
    expected_api_version = ShopifyApp.configuration.api_version

    assert_equal expected_api_version, shop.api_version
  end
end
