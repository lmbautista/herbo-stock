# frozen_string_literal: true

require "test_helper"

module Catalog
  class LoaderTest < ActiveSupport::TestCase
    test "has audit" do
      assert_includes Loader.included_modules, WithAudit
    end

    test "success" do
      loader = Loader.new(file_fixture("raw_catalog.csv"))

      assert_difference "Audit.succeeded.count", +1 do
        assert_difference "V1::Product.count", +1 do
          response = loader.call

          assert response.success?
        end
      end
    end

    test "fails" do
      loader = Loader.new(file_fixture("raw_catalog.csv"))
      error_messages = %w(error1 error2)
      expected_error = error_messages.to_sentence

      mock_products_raw_adapter(error_messages)

      assert_difference "Audit.failed.count", +1 do
        assert_no_difference "V1::Product.count" do
          response = loader.call

          assert response.failure?
          assert_equal expected_error, response.value
        end
      end
    end

    private

    def mock_products_raw_adapter(error_messages)
      ar_errors = mock
      ar_errors.expects(:full_messages).returns(Array.wrap(error_messages))

      V1::Product.any_instance.stubs(:save).returns(false)
      V1::Product.any_instance.stubs(:errors).returns(ar_errors)
    end
  end
end
