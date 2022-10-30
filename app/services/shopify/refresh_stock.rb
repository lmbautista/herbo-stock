# frozen_string_literal: true

module Shopify
  class RefreshStock
    include WithAudit

    def initialize(shop_domain:, skus:)
      @shop_domain = shop_domain
      @skus = skus
      @resume = []
    end

    def call
      with_audit(operation_id: operation_id, params: params, shop: shop) do
        load_fulfillment_service_products
          .and_then { refresh_products_stock }
          .and_then { Response.success(resume.to_sentence) }
      end
    end

    private

    attr_reader :shop_domain, :skus, :csv_data, :resume

    def shop
      @shop ||= ::Shop.find_by(shopify_domain: shop_domain)
    end

    def load_fulfillment_service_products
      url = fulfillment_service.get_url_for_source("stock_and_prices")
      response = RestClient.get(url)

      return Response.failure("Fulfillment service unavailable") if response.code != 200

      raw_content = response.body
      @csv_data = StringIO.new(raw_content)
      csv_data.set_encoding_by_bom

      Response.success("Ok")
    end

    def refresh_products_stock
      filtered_products.each do |row_data|
        refresh_product_stock(row_data)
          .and_then { |product| set_inventory_level_with_response(product) }
          .and_then { |product| add_success(product) }
      end

      Response.success(resume.to_sentence)
    end

    def filtered_products
      csv_options = { headers: true, col_sep: ";" }
      data = CSV.parse(csv_data, **csv_options)

      return data if skus.blank?

      data.select { skus.include?(_1["sku"].to_s) }
    end

    def refresh_product_stock(row_data)
      product = V1::Product.find_by(sku: row_data["sku"])

      if product.blank?
        error_message = "Product with SKU #{row_data["sku"]} not found"
        resume << error_message
        Response.failure(error_message)
      else
        product.disponible = row_data["disponible"]
        product.save ? Response.success(product) : response_failure(product)
      end
    end

    def set_inventory_level_with_response(product) # rubocop:disable Naming/AccessorMethodName
      product.fulfillment_service
        .set_inventory_level(product.external_id, product.disponible)
    end

    def add_success(product)
      message = "#{product.class}##{product.id} refreshed successfully"

      resume << message
    end

    def fulfillment_service
      @fulfillment_service ||=
        ::Shopify::FulfillmentServices::Distribudiet.new(shop.id)
    end

    def operation_id
      "Refresh products stock"
    end

    def params
      { skus: skus }
    end

    def response_failure(record)
      id_error_message = "#{record.class}##{record.id}:"
      error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

      Response.failure(error_message)
    end
  end
end
