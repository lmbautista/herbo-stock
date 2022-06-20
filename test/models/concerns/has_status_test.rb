# frozen_string_literal: true

require "test_helper"

class HasStatusTest < ActiveSupport::TestCase
  TEST_TABLE_NAME = "application_record_test_has_status"

  class Record < ApplicationRecord
    self.table_name = TEST_TABLE_NAME

    include HasStatus

    has_status attribute: :status_attribute,
               statuses: %i(a b),
               allowed_transitions: { a: %i(b) }
  end

  class ChildRecord < Record
  end

  setup do
    ActiveRecord::Base.connection.create_table(TEST_TABLE_NAME, temporary: true) do |t|
      t.string :status_attribute
      t.string :type
    end
  end

  test "status is whitelisted" do
    exception = assert_raises ArgumentError do
      Record.new(status_attribute: "invalid status")
    end

    assert_equal "'invalid status' is not a valid status_attribute", exception.message
  end

  test "status is mandatory" do
    record = Record.new(status_attribute: nil)

    assert record.invalid?
    assert record.errors.added?(:status_attribute, :blank)
  end

  test "status is valid" do
    record = Record.new(status_attribute: "a")

    assert record.valid?
  end

  test "child inherits the status" do
    record = ChildRecord.new(status_attribute: "a")

    assert record.valid?
  end

  test "transitions are whitelisted" do
    record = Record.create!(status_attribute: "b")
    expected_error_message = "Status attribute transition to a is not allowed"
    record.status_attribute = "a"

    assert record.invalid?
    assert record.errors.added?(:status_attribute, :transition_not_allowed)
    assert_equal expected_error_message, record.errors.full_messages.to_sentence
  end

  test "transitions are allowed" do
    record = Record.create!(status_attribute: "a")

    record.status_attribute = "b"

    assert record.valid?
    assert_equal "b", record.status_attribute
  end

  teardown do
    ActiveRecord::Base.connection.drop_table(TEST_TABLE_NAME, force: true)
  end
end
