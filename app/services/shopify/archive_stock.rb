# frozen_string_literal: true

module Shopify
  class ArchiveStock
    include WithAudit

    def initialize(shop_domain)
      @shop_domain = shop_domain
      @resume = []
      @sku_list = []
    end

    def call
      with_audit(operation_id: operation_id, params: params, shop: shop) do
        load_fulfillment_service_skus("all_products", "SKU")
          .and_then { load_fulfillment_service_skus("stock_and_prices", "sku") }
          .and_then { archive_products_stock }
          .and_then { Response.success(resume.to_sentence) }
      end
    end

    private

    attr_reader :shop_domain, :sku_list, :resume

    def shop
      @shop ||= ::Shop.find_by(shopify_domain: shop_domain)
    end

    def load_fulfillment_service_skus(source, key)
      url = fulfillment_service.get_url_for_source(source)
      response = RestClient.get(url)

      return Response.failure("Fulfillment service unavailable") if response.code != 200

      raw_content = response.body
      csv_data = StringIO.new(raw_content)
      csv_data.set_encoding_by_bom

      csv_options = { headers: true, col_sep: ";" }
      data = CSV.parse(csv_data, **csv_options)
      sku_list << data.map { _1[key] }

      Response.success("Ok")
    end

    def archive_products_stock
      products_to_archive.each do |product|
        archive_product_stock(product)
          .and_then { set_inventory_level_with_response(product) }
          .and_then { update_shopify_product(product) }
          .on_failure { return Response.success("Ok") }
      end

      Response.success(resume.to_sentence)
    end

    def products_to_archive
      ::V1::Product.where.not(sku: sku_list.flatten.uniq)
    end

    def archive_product_stock(product)
      product.disponible = 0
      product.save ? Response.success(product) : response_failure(product)
    end

    def set_inventory_level_with_response(product) # rubocop:disable Naming/AccessorMethodName
      return Response.success(product) unless product.disponible_previously_changed?

      product.fulfillment_service
        .set_inventory_level(product.external_id, product.disponible)
        .and_then do |message|
          resume << "#{message} for product with SKU #{product.sku}"
          Response.success(product)
        end
    end

    def update_shopify_product(product)
      return Response.success(product) unless product.disponible_previously_changed?

      product.shopify_adapter.to_product.save_with_response
        .on_failure { |error| resume << "Cannot upsert Shopify product: #{error}" }
    end

    def fulfillment_service
      @fulfillment_service ||=
        ::Shopify::FulfillmentServices::Distribudiet.new(shop.id)
    end

    def operation_id
      "Archive products stock"
    end

    def params
      {}
    end

    def response_failure(record)
      id_error_message = "#{record.class}##{record.id}:"
      error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

      Response.failure(error_message)
    end
  end
end
