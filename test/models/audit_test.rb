# frozen_string_literal: true

require "test_helper"

class AuditTest < ActiveSupport::TestCase
  test "has status" do
    assert_includes Audit.included_modules, HasStatus
  end

  test "operation_id is required" do
    audit = build(:audit, operation_id: nil)

    assert audit.invalid?
    assert audit.errors.added?(:operation_id, :blank)
  end

  test "status is required" do
    audit = build(:audit, status: nil)

    assert audit.invalid?
    assert audit.errors.added?(:status, :blank)
  end

  test "raw_params is required" do
    audit = build(:audit, raw_params: nil)

    assert audit.invalid?
    assert audit.errors.added?(:raw_params, :blank)
  end

  test "started_at is required" do
    audit = build(:audit, started_at: nil)

    assert audit.invalid?
    assert audit.errors.added?(:started_at, :blank)
  end

  test "succeeded_at is required if status is succeeded" do
    audit = build(:audit, :succeeded, succeeded_at: nil)

    assert audit.invalid?
    assert audit.errors.added?(:succeeded_at, :blank)
  end

  test "#succeeded_with_message!" do
    expected_message = "message"
    audit = create(:audit)

    assert_changes -> { audit.reload.message }, to: expected_message do
      audit.succeeded_with_message!(expected_message)

      assert audit.succeeded?
    end
  end

  test "failed_at is required if status is failed" do
    audit = build(:audit, :failed, failed_at: nil)

    assert audit.invalid?
    assert audit.errors.added?(:failed_at, :blank)
  end

  test "#failed_with_message!" do
    expected_error_message = "error_message"
    audit = create(:audit)

    assert_changes -> { audit.reload.message }, to: expected_error_message do
      audit.failed_with_message!(expected_error_message)

      assert audit.failed?
    end
  end

  test "shopify_domain is required" do
    audit = build(:audit, shop_domain: nil)

    assert audit.invalid?
    assert audit.errors.added?(:shop_domain, :blank)
  end

  test "#shop" do
    audit = create(:audit)

    assert audit.shop.persisted?
  end

  test "clean up old records" do
    Audit.send(:remove_const, "AUDITS_LIMIT")
    Audit.send(:const_set, "AUDITS_LIMIT", 1)
    shop = create(:shop, shopify_domain: "whatever.com")
    cleaned_up_audit = create(:audit, shop_domain: shop.shopify_domain)
    audit = create(:audit)

    audits = Audit.all

    assert_includes audits, audit
    assert_not_includes audits, cleaned_up_audit
  end
end
