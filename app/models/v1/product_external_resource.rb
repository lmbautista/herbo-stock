# frozen_string_literal: true

class V1::ProductExternalResource < ApplicationRecord
  belongs_to :product, class_name: "V1::Product", foreign_key: "v1_product_id"

  ALLOWED_KINDS = [
    KIND_SHOPIFY_PRODUCT = "shopify_product",
    KIND_SHOPIFY_VARIANT = "shopify_variant"
  ].freeze

  enum kind: ALLOWED_KINDS.reduce({}) { |acc, value| acc.merge!(value.to_sym => value.to_s) }

  validates :kind, presence: true
  validates :external_id, presence: true
end
