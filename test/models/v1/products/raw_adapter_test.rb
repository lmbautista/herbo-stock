# frozen_string_literal: true

require "test_helper"

module V1
  module Products
    class RawAdapterTest < ActiveSupport::TestCase
      test "#payload" do
        expected_payload = "d4da4d158ad780a18c21d7de052bcfaa"
        raw_adapter = RawAdapter.new(data)
        payload = raw_adapter.payload

        assert_equal expected_payload, Digest::MD5.hexdigest(payload.to_json)
        assert_equal expected_keys, payload.keys
      end

      test "#build_v1_product" do
        raw_adapter = RawAdapter.new(data)
        product = raw_adapter.build_v1_product

        assert product.valid?
        assert product.save
      end

      private

      def data
        @data ||= CSV.read(file_fixture("raw_catalog.csv"), headers: true, col_sep: ";").first
      end

      def expected_keys
        %i(
          id
          sku
          definicion
          ampliacion
          disponible
          iva
          req_eq
          pvd
          pvd_iva
          pvd_iva_rec
          pvp
          peso
          ean
          hay_foto
          imagen
          fecha_imagen
          cat
          marca
          frio
          congelado
          bio
          apto_diabetico
          gluten
          huevo
          lactosa
          apto_vegano
          unidad_medida
          cantidad_medida
        )
      end
    end
  end
end
