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

  test "failed_at is required if status is failed" do
    audit = build(:audit, :failed, failed_at: nil)

    assert audit.invalid?
    assert audit.errors.added?(:failed_at, :blank)
  end
end
