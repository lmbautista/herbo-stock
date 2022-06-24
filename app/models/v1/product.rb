# frozen_string_literal: true

module V1
  class Product < ApplicationRecord
    belongs_to :shop
    has_many :product_external_resources

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
    validates :ean, presence: true
    validates :hay_foto, inclusion: [true, false]
    validates :imagen, presence: true
    validates :fecha_imagen, presence: true
    validates :cat, presence: true
    validates :marca, presence: true
    validates :frio, inclusion: [true, false]
    validates :congelado, inclusion: [true, false]
    validates :bio, inclusion: [true, false]
    validates :apto_diabetico, inclusion: [true, false]
    validates :gluten, inclusion: [true, false]
    validates :huevo, inclusion: [true, false]
    validates :lactosa, inclusion: [true, false]
    validates :apto_vegano, inclusion: [true, false]
    validates :unidad_medida, presence: true
    validates :cantidad_medida, presence: true,
                                numericality: { only_float: true, greater_than_or_equal_to: 0.0 }

    def shopify_adapter
      @shopify_adapter ||= V1::Products::Shopify::Adapter.new(self)
    end
  end
end
