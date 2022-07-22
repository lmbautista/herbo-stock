# frozen_string_literal: true

module Shopify
  class ProductVariant
    include Virtus.model

    attribute :id, Integer
    attribute :price, Float
    attribute :sku, String
    attribute :barcode, String
    attribute :weight, Float
    attribute :weight_unit, String
    attribute :taxable, Boolean
    attribute :fulfillment_service, String
    attribute :inventory_policy, String
    attribute :inventory_quantity, Integer
    attribute :inventory_management, String
    attribute :inventory_item_id, Integer
    attribute :requires_shipping, Boolean
  end
end
