# frozen_string_literal: true

require "test_helper"

class JsonValidatorTest < ActiveSupport::TestCase
  TEST_TABLE_NAME = "application_record_test_json_validator"

  class Record < ApplicationRecord
    self.table_name = TEST_TABLE_NAME

    validates :json_attribute, presence: true, json: true
  end

  class ChildRecord < Record
  end

  setup do
    ActiveRecord::Base.connection.create_table(TEST_TABLE_NAME, temporary: true) do |t|
      t.json :json_attribute
    end
  end

  test "success when JSON format is right" do
    child = ChildRecord.new(json_attribute: { a: 1, b: 1 })

    assert child.valid?
  end

  test "fails when JSON format is wrong" do
    child = ChildRecord.new(json_attribute: "invalid JSON")
    exception_message = "859: unexpected token at 'invalid JSON'"

    assert child.invalid?
    assert child.errors.added?(:json_attribute, :invalid, exception_message: exception_message)
  end
end
