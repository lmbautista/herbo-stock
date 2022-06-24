# frozen_string_literal: true

require "test_helper"

class V1::ProductExternalResourceTest < ActiveSupport::TestCase
  test "kind is required" do
    product_external_resource = build(:v1_product_external_resource, kind: nil)

    assert product_external_resource.invalid?
    assert product_external_resource.errors.added?(:kind, :blank)
  end
  test "external_id is required" do
    product_external_resource = build(:v1_product_external_resource, external_id: nil)

    assert product_external_resource.invalid?
    assert product_external_resource.errors.added?(:external_id, :blank)
  end
end
