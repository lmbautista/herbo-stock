# frozen_string_literal: true

module V1
  class Product < ApplicationRecord
    belongs_to :shop
    has_many :product_external_resources,
             foreign_key: "v1_product_id",
             dependent: :destroy

    validates :sku, presence: true
    validates :definicion, presence: true
    validates :ampliacion, presence: true
    validates :disponible, presence: true,
                           numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :iva, presence: true,
                    numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :req_eq, presence: true,
                       numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :pvd, presence: true,
                    numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :pvd_iva, presence: true,
                        numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :pvd_iva_rec, presence: true,
                            numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :pvp, presence: true,
                    numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :peso, presence: true,
                     numericality: { only_float: true, greater_than_or_equal_to: 0.0 }
    validates :hay_foto, inclusion: [true, false]
    validates :imagen, presence: true
    validates :fecha_imagen, presence: true
    validates :cat, presence: true
    validates :frio, inclusion: [true, false]
    validates :congelado, inclusion: [true, false]
    validates :bio, inclusion: [true, false]
    validates :apto_diabetico, inclusion: [true, false]
    validates :gluten, inclusion: [true, false]
    validates :huevo, inclusion: [true, false]
    validates :lactosa, inclusion: [true, false]
    validates :apto_vegano, inclusion: [true, false]
    validates :cantidad_medida, presence: true,
                                numericality: { only_float: true, greater_than_or_equal_to: 0.0 }

    def has_been_created!
      @has_been_created = !has_been_created
    end

    def has_been_created?
      has_been_created
    end

    def has_been_updated!
      @has_been_updated = !has_been_updated
    end

    def has_been_updated?
      has_been_updated
    end

    def shopify_adapter
      @shopify_adapter ||= V1::Products::Shopify::Adapter.new(self)
    end

    delegate :fulfillment_service, to: :shopify_adapter

    def find_or_initialize_external_product
      product_external_resources
        .find_or_initialize_by(kind: ProductExternalResource::KIND_SHOPIFY_PRODUCT)
    end

    delegate :external_id, to: :find_or_initialize_external_product

    private

    attr_reader :has_been_updated, :has_been_created
  end
end
