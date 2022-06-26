# frozen_string_literal: true

module Shopify
  class ProductImage
    include Virtus.model

    attribute :position, Integer
    attribute :alt, String
    attribute :src, String
  end
end
