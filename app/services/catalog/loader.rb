# frozen_string_literal: true

module Catalog
  class Loader
    include WithAudit

    def initialize(input_path, shop_id, product_ids = [])
      @input_path = input_path
      @shop_id = shop_id
      @product_ids = Array.wrap(product_ids).select(&:present?).map(&:to_s)
      @resume = []
    end

    def model_name
      Struct.new(:param_key).new(:catalog_loader)
    end

    def call
      with_audit(operation_id: operation_id, params: params, shop: Shop.find(shop_id)) do
        filtered_products.each do |row_data|
          load_product(row_data)
            .and_then { |_, product| upsert_shopify_product(product) }
            .and_then { |product| set_inventory_level_with_response(product) }
        end

        Response.success(resume.to_sentence)
      end
    end

    private

    attr_reader :resume, :input_path, :shop_id, :product_ids

    def params
      {
        shop_id: shop_id,
        product_ids: product_ids
      }
    end

    def filtered_products
      data = CSV.read(input_path, **csv_options)
      return data.take(2) if product_ids.blank?

      data.select { product_ids.include?(_1["id"].to_s) }
    end

    def csv_options
      { headers: true, col_sep: ";", encoding: "bom|utf-8" }
    end

    def shop
      @shop ||= ::Shop.find(shop_id)
    end

    def operation_id
      "Load catalog"
    end

    def load_product(row_data)
      Product::Loader.new(row_data, shop.id).call
    end

    def upsert_shopify_product(product)
      product.shopify_adapter.to_product.save_with_response
        .on_failure { |error| resume << "Cannot upsert Shopify product: #{error}" }
        .and_then { |shopify_product| save_shopify_product_id(product, shopify_product) }
    end

    def save_shopify_product_id(product, shopify_product)
      external_product = product.find_or_initialize_external_product
      external_product.external_id = shopify_product.id

      external_product.save ? add_success(product) : add_failure(external_product)

      Response.success(product)
    end

    def set_inventory_level_with_response(product) # rubocop:disable Naming/AccessorMethodName
      return Response.success(product) if product.external_id.blank?

      product.fulfillment_service.set_inventory_level(product.external_id, product.disponible)
    end

    def add_failure(record)
      id_error_message = "#{record.class}##{record.id}:"
      error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

      resume << error_message
    end

    def add_success(record)
      message = "#{record.class}##{record.id} loaded successfully"

      resume << message
    end
  end
end
