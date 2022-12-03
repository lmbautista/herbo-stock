# frozen_string_literal: true

module V1
  module Products
    class RawAdapter
      def initialize(data, shop_id)
        @data = data
        @shop = Shop.find(shop_id)
      end

      def payload # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        {
          id: data.fetch("id"),
          shop_id: shop.id,
          sku: data.fetch("SKU"),
          definicion: data.fetch("DEFINICION"),
          ampliacion: data.fetch("AMPLIACION"),
          disponible: data.fetch("DISPONIBLE"),
          iva: data.fetch("IVA"),
          req_eq: data.fetch("REC_EQ"),
          pvd: data.fetch("PVD"),
          pvd_iva: data.fetch("PVD_IVA"),
          pvd_iva_rec: data.fetch("PVD_IVA_REC"),
          pvp: data.fetch("PVP"),
          peso: data.fetch("PESO"),
          ean: data.fetch("EAN"),
          hay_foto: data.fetch("HAY_FOTO"),
          imagen: data.fetch("IMAGEN"),
          fecha_imagen: data.fetch("FECHA_IMAGEN"),
          cat: data.fetch("CAT"),
          marca: data.fetch("MARCA"),
          frio: with_boolean_fallback_for("FRIO"),
          congelado: with_boolean_fallback_for("CONGELADO"),
          bio: with_boolean_fallback_for("BIO"),
          apto_diabetico: with_boolean_fallback_for("APTO_DIABETICO"),
          gluten: with_boolean_fallback_for("GLUTEN"),
          huevo: with_boolean_fallback_for("HUEVO"),
          lactosa: with_boolean_fallback_for("LACTOSA"),
          apto_vegano: with_boolean_fallback_for("APTO_VEGANO"),
          unidad_medida: data.fetch("UNIDAD_MEDIDA"),
          cantidad_medida: data.fetch("CANTIDAD_MEDIDA")
        }
      end

      def find_or_build_v1_product
        product = V1::Product.find_by(id: payload.fetch(:id), shop_id: shop.id)

        if product.present?
          product.assign_attributes(**payload)
          product.has_been_updated! if product.changed?
        else
          product = V1::Product.new(**payload)
          product.has_been_created!
        end
        product
      end

      private

      attr_reader :data, :shop

      def with_boolean_fallback_for(field_name)
        data.fetch(field_name).presence || 0
      end
    end
  end
end
