# frozen_string_literal: true

require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "should create a response" do
    expected_value = "response_value"
    response = Response.new(success: true, value: expected_value)

    assert response.success?
    assert_equal expected_value, response.value
    assert_nil response.resource
  end

  test "should create a response with resource" do
    expected_value = "response_value"
    expected_resource = { a: 1 }
    response = Response.new(success: true, value: expected_value, resource: expected_resource)

    assert response.success?
    assert_equal expected_value, response.value
    assert_equal expected_resource, response.resource
  end

  test "should create response with nil value" do
    response = Response.new(success: false)

    assert response.failure?
    assert_nil response.value
  end

  test "should create a success response" do
    expected_value = "response_value"
    response = Response.success(expected_value)

    assert response.success?
    assert_equal expected_value, response.value
  end

  test "should create a failure response" do
    expected_value = "response_value"
    response = Response.failure(expected_value)

    assert response.failure?
    assert_equal expected_value, response.value
  end

  test "and_then propagate value and resource if response success" do
    my_sum = ->(x, y) { Response.success(x + y) }

    response = my_sum.call(1, 1)
      .and_then { |sum_one| Response.success(:ok, sum_one + 1) }
      .and_then { |_message, sum_two| Response.success(:ok, sum_two + 1) }

    assert response.success?
    assert_equal :ok, response.value
    assert_equal 4, response.resource
  end

  test "and_then dont propagate value if response failure" do
    my_sum = ->(x, y) { Response.success(x + y) }

    response = my_sum.call(1, 1)
      .and_then { Response.failure(99) }
      .and_then { |sum_two| Response.success(sum_two + 1) }

    assert response.failure?
    assert_equal 99, response.value
  end
end
