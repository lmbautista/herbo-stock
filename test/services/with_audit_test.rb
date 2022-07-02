# frozen_string_literal: true

require "test_helper"

class WithAuditTest < ActiveSupport::TestCase
  class DummyService
    include WithAudit

    def initialize(params:, response:, shop:)
      @params = params
      @response = response
      @shop = shop
    end

    def call
      with_audit(operation_id: self.class.to_s, shop: @shop, params: @params) do
        @response
      end
    end
  end

  class DummyServiceWithBug
    include WithAudit

    def initialize(params:, shop:)
      @params = params
      @shop = shop
    end

    def call
      with_audit(operation_id: self.class.to_s, shop: @shop, params: @params) do
        whatever
      end
    end
  end

  test "success" do
    expected_response = Response.success(:ok!)
    dummy = DummyService.new(params: params, response: expected_response, shop: shop)

    assert_difference "Audit.count", +1 do
      response = dummy.call
      audit = Audit.last

      assert response.success?
      assert audit.succeeded?
      assert_equal DummyService.to_s, audit.operation_id
      assert_equal params.to_json, audit.raw_params
      assert_equal expected_response, response
    end
  end

  test "failed" do
    expected_response = Response.failure(:ok!)
    dummy = DummyService.new(params: params, response: expected_response, shop: shop)

    assert_difference "Audit.count", +1 do
      response = dummy.call
      audit = Audit.last

      assert response.failure?
      assert audit.failed?
      assert_equal DummyService.to_s, audit.operation_id
      assert_equal params.to_json, audit.raw_params
      assert_equal expected_response, response
    end
  end

  test "failed with unexpected exception" do
    error_message = /Unexpected exception: undefined local variable or method `whatever/

    dummy = DummyServiceWithBug.new(params: params, shop: shop)

    assert_difference "Audit.count", +1 do
      response = dummy.call
      audit = Audit.last

      assert response.failure?
      assert audit.failed?
      assert_equal DummyServiceWithBug.to_s, audit.operation_id
      assert_equal params.to_json, audit.raw_params
      assert_match error_message, response.value
    end
  end

  private

  def params
    { a: 1, b: 2 }
  end

  def shop
    @shop ||= create(:shop)
  end
end
