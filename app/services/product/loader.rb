# frozen_string_literal: true

module Product
  class Loader
    include WithAudit

    def initialize(data, shop_id)
      @data = data.to_h
      @shop_id = shop_id
    end

    def call
      with_audit(operation_id: operation_id, params: data, shop: Shop.find(shop_id)) do
        adapter = ::V1::Products::RawAdapter.new(data, shop_id)
        product = adapter.find_or_build_v1_product
        @action = product.persisted? ? "updated" : "created"

        save_product_with_response(product)
          .and_then { response_success(product) }
      end
    end

    private

    attr_reader :data, :shop_id, :action

    def operation_id
      "Load product"
    end

    def save_product_with_response(product)
      product.save ? Response.success(product) : response_failure(product)
    end

    def response_failure(record)
      id_error_message = "#{record.class}##{record.id}:"
      error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

      Response.failure(error_message)
    end

    def response_success(record)
      message = "Product '#{record.definicion}' with SKU #{record.sku} was #{action} successfully"

      Response.success(message, record)
    end
  end
end
