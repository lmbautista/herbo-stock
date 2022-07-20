# frozen_string_literal: true

require "test_helper"

module Product
  class LoaderTest < ActiveSupport::TestCase
    test "has audit" do
      assert_includes Loader.included_modules, WithAudit
    end

    test "create successfully" do
      expected_message = "Product 'COPOS DE AVENA 1000GR' with SKU 01003 was created successfully"

      assert_difference "V1::Product.count", +1 do
        assert_difference "Audit.succeeded.count", +1 do
          response = Loader.new(data, shop.id).call

          assert response.success?
          assert_equal expected_message, response.value
          assert_kind_of V1::Product, response.resource
        end
      end
    end

    test "update successfully" do
      product = create(:v1_product, id: 1003, shop: shop)
      expected_message = "Product 'COPOS DE AVENA 1000GR' with SKU 01003 was updated successfully"

      assert_no_difference "V1::Product.count" do
        assert_difference "Audit.succeeded.count", +1 do
          assert_changes -> { product.reload.sku } do
            response = Loader.new(data, shop.id).call

            assert response.success?
            assert_equal expected_message, response.value
            assert_kind_of V1::Product, response.resource
          end
        end
      end
    end

    test "fails due to raw adapter" do
      error_messages = %w(error1 error2)
      expected_error = "V1::Product#1003: #{error_messages.to_sentence}"

      ar_errors = mock
      ar_errors.expects(:full_messages).returns(Array.wrap(error_messages))

      V1::Product.any_instance.stubs(:save).returns(false)
      V1::Product.any_instance.stubs(:errors).returns(ar_errors)

      assert_difference "Audit.failed.count", +1 do
        assert_no_difference "V1::Product.count" do
          response = Loader.new(data, shop.id).call

          assert response.failure?
          assert_equal expected_error, response.value
        end
      end
    end

    private

    def data
      @data ||= CSV.read(file_fixture("raw_catalog.csv"), **csv_options).first
    end

    def csv_options
      { headers: true, col_sep: ";", encoding: "bom|utf-8" }
    end

    def shop
      @shop ||= create(:shop)
    end
  end
end
