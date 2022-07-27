# frozen_string_literal: true

require "test_helper"

class CatalogLoaderSchedulerTest < ActiveSupport::TestCase
  test "time_unit is required" do
    scheduler = build(:catalog_loader_scheduler, time_unit: nil)

    assert scheduler.invalid?
    assert scheduler.errors.added?(:time_unit, :blank)
  end

  test "time_amount is required" do
    scheduler = build(:catalog_loader_scheduler, time_amount: nil)

    assert scheduler.invalid?
    assert scheduler.errors.added?(:time_amount, :blank)
  end

  test "time_amount only accepts intenger greather or equal to zero" do
    scheduler = build(:catalog_loader_scheduler, time_amount: -1)

    assert scheduler.invalid?
    assert scheduler.errors.added?(:time_amount, :greater_than_or_equal_to, value: -1, count: 0)
  end
end
