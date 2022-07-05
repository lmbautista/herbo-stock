# frozen_string_literal: true

module Catalog
  class Loader
    include WithAudit

    def initialize(input_path, shop_id, product_ids = [])
      @input_path = input_path
      @shop_id = shop_id
      @product_ids = Array.wrap(product_ids).select(&:present?).map(&:to_s)
      @responses = []
    end

    def model_name
      Struct.new(:param_key).new(:catalog_loader)
    end

    def call
      load_catalog
      return Response.success(input_path) if responses.all?(&:success?)

      error_message = responses.select(&:failure?).map(&:value).to_sentence
      Response.failure(error_message)
    end

    private

    attr_reader :responses, :input_path, :shop_id, :product_ids

    def load_catalog
      filtered_products.each do |row_data|
        adapter = V1::Products::RawAdapter.new(row_data.to_h, shop_id)

        with_audit(operation_id: operation_id, params: row_data, shop: shop) do
          generate_product_with_response(adapter)
            .and_then { |product| save_product_with_response(product) }
            .and_then { |product| upsert_shopify_product_with_response(product) }
            .on_failure { |error| responses << Response.failure(error) }
        end
      end
    end

    def filtered_products
      data = CSV.read(input_path, **csv_options)
      return data if product_ids.blank?

      data.select { product_ids.include?(_1["id"].to_s) }
    end

    def build_and_sync_shopify_product(adapter)
      generate_product_with_response(adapter)
        .and_then { |product| save_product_with_response(product) }
        .and_then { |product| upsert_shopify_product_with_response(product) }
        .on_failure { |error| responses << Response.failure(error) }
    end

    def csv_options
      { headers: true, col_sep: ";", encoding: "bom|utf-8" }
    end

    def shop
      @shop ||= ::Shop.find(shop_id)
    end

    def generate_product_with_response(adapter)
      Response.success(adapter.find_or_build_v1_product)
    end

    def upsert_shopify_product_with_response(product)
      product.shopify_adapter.to_product.save_with_response
        .and_then do |shopify_product|
          external_product = product.find_or_initialize_external_product
          external_product.external_id = shopify_product.id

          external_product.save ? Response.success(product) : response_failure(external_product)
        end
    end

    def save_product_with_response(product)
      product.save ? Response.success(product) : response_failure(product)
    end

    def operation_id
      self.class.to_s
    end

    def response_failure(record)
      id_error_message = "#{record.class}##{record.id}:"
      error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

      Response.failure(error_message)
    end
  end
end
