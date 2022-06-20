# frozen_string_literal: true

module V1
  module Products
    class RawAdapter
      def initialize(data)
        @data = data
      end

      def payload # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        {
          id: data.fetch("id"),
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
          frio: data.fetch("FRIO"),
          congelado: data.fetch("CONGELADO"),
          bio: data.fetch("BIO"),
          apto_diabetico: data.fetch("APTO_DIABETICO"),
          gluten: data.fetch("GLUTEN"),
          huevo: data.fetch("HUEVO"),
          lactosa: data.fetch("LACTOSA"),
          apto_vegano: data.fetch("APTO_VEGANO"),
          unidad_medida: data.fetch("UNIDAD_MEDIDA"),
          cantidad_medida: data.fetch("CANTIDAD_MEDIDA")
        }
      end

      def build_v1_product
        V1::Product.new(payload)
      end

      private

      attr_reader :data
    end
  end
end
