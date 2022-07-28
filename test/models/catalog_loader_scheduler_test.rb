# frozen_string_literal: true

require "test_helper"

class CatalogLoaderSchedulerTest < ActiveSupport::TestCase
  test "next_scheduled_at is required when has process_id" do
    scheduler = build(:catalog_loader_scheduler, next_scheduled_at: nil, process_id: "process_id")

    assert scheduler.invalid?
    assert scheduler.errors.added?(:next_scheduled_at, :blank)
  end

  test "process_id is required when has next_scheduled_at" do
    scheduler = build(:catalog_loader_scheduler, next_scheduled_at: Time.current, process_id: nil)

    assert scheduler.invalid?
    assert scheduler.errors.added?(:process_id, :blank)
  end

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

  test "#schedule" do
    scheduler = build(:catalog_loader_scheduler, next_scheduled_at: nil)

    freeze_time do
      expected_next_scheduled_at = 1.minute.from_now
      expected_process_id = SecureRandom.hex(12)

      assert scheduler.schedule(expected_process_id)
      assert_equal expected_next_scheduled_at, scheduler.next_scheduled_at
      assert_equal expected_process_id, scheduler.process_id
    end
  end

  test "#repeat" do
    first_scheduled_at = Time.current.yesterday
    scheduler = create(:catalog_loader_scheduler,
                       next_scheduled_at: first_scheduled_at, process_id: "abc123")

    freeze_time do
      expected_next_scheduled_at = 1.minute.from_now
      assert_changes -> { scheduler.reload.next_scheduled_at },
                     from: first_scheduled_at,
                     to: expected_next_scheduled_at do
        assert scheduler.repeat
      end
    end
  end
end
