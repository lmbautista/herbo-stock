# frozen_string_literal: true

FactoryBot.define do
  factory :shop, class: "Shop" do
    shopify_domain { "test.shopify.shop" }
    shopify_token { "abc1234" }
  end
end
