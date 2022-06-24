# frozen_string_literal: true

FactoryBot.define do
  factory :v1_product_external_resource, class: "V1::ProductExternalResource" do
    product { build(:v1_product) }
    external_id { 1 }
    kind { V1::ProductExternalResource::KIND_SHOPIFY_PRODUCT }
  end
end
