# frozen_string_literal: true

require "test_helper"

module V1
  class ProductTest < ActiveSupport::TestCase
    test "shop_id is required" do
      product = build(:v1_product, shop_id: nil)

      assert product.invalid?
      assert product.errors.added?(:shop, :blank)
    end

    test "sku is required" do
      product = build(:v1_product, sku: nil)

      assert product.invalid?
      assert product.errors.added?(:sku, :blank)
    end

    test "definicion is required" do
      product = build(:v1_product, definicion: nil)

      assert product.invalid?
      assert product.errors.added?(:definicion, :blank)
    end

    test "ampliacion is required" do
      product = build(:v1_product, ampliacion: nil)

      assert product.invalid?
      assert product.errors.added?(:ampliacion, :blank)
    end

    test "disponible is required" do
      product = build(:v1_product, disponible: nil)

      assert product.invalid?
      assert product.errors.added?(:disponible, :blank)
    end

    test "iva is required" do
      product = build(:v1_product, iva: nil)

      assert product.invalid?
      assert product.errors.added?(:iva, :blank)
    end

    test "req_eq is required" do
      product = build(:v1_product, req_eq: nil)

      assert product.invalid?
      assert product.errors.added?(:req_eq, :blank)
    end

    test "pvd is required" do
      product = build(:v1_product, pvd: nil)

      assert product.invalid?
      assert product.errors.added?(:pvd, :blank)
    end

    test "pvd_iva is required" do
      product = build(:v1_product, pvd_iva: nil)

      assert product.invalid?
      assert product.errors.added?(:pvd_iva, :blank)
    end

    test "pvd_iva_rec is required" do
      product = build(:v1_product, pvd_iva_rec: nil)

      assert product.invalid?
      assert product.errors.added?(:pvd_iva_rec, :blank)
    end

    test "pvp is required" do
      product = build(:v1_product, pvp: nil)

      assert product.invalid?
      assert product.errors.added?(:pvp, :blank)
    end

    test "peso is required" do
      product = build(:v1_product, peso: nil)

      assert product.invalid?
      assert product.errors.added?(:peso, :blank)
    end

    test "ean is required" do
      product = build(:v1_product, ean: nil)

      assert product.invalid?
      assert product.errors.added?(:ean, :blank)
    end

    test "hay_foto is invalid" do
      product = build(:v1_product, hay_foto: nil)

      assert product.invalid?
      assert product.errors.added?(:hay_foto, :inclusion, value: nil)
    end

    test "imagen is required" do
      product = build(:v1_product, imagen: nil)

      assert product.invalid?
      assert product.errors.added?(:imagen, :blank)
    end

    test "fecha_imagen is required" do
      product = build(:v1_product, fecha_imagen: nil)

      assert product.invalid?
      assert product.errors.added?(:fecha_imagen, :blank)
    end

    test "cat is required" do
      product = build(:v1_product, cat: nil)

      assert product.invalid?
      assert product.errors.added?(:cat, :blank)
    end

    test "marca is required" do
      product = build(:v1_product, marca: nil)

      assert product.invalid?
      assert product.errors.added?(:marca, :blank)
    end

    test "frio is invalid" do
      product = build(:v1_product, frio: nil)

      assert product.invalid?
      assert product.errors.added?(:frio, :inclusion, value: nil)
    end

    test "congelado is invalid" do
      product = build(:v1_product, congelado: nil)

      assert product.invalid?
      assert product.errors.added?(:congelado, :inclusion, value: nil)
    end

    test "bio is invalid" do
      product = build(:v1_product, bio: nil)

      assert product.invalid?
      assert product.errors.added?(:bio, :inclusion, value: nil)
    end

    test "apto_diabetico is invalid" do
      product = build(:v1_product, apto_diabetico: nil)

      assert product.invalid?
      assert product.errors.added?(:apto_diabetico, :inclusion, value: nil)
    end

    test "gluten is invalid" do
      product = build(:v1_product, gluten: nil)

      assert product.invalid?
      assert product.errors.added?(:gluten, :inclusion, value: nil)
    end

    test "huevo is invalid" do
      product = build(:v1_product, huevo: nil)

      assert product.invalid?
      assert product.errors.added?(:huevo, :inclusion, value: nil)
    end

    test "lactosa is invalid" do
      product = build(:v1_product, lactosa: nil)

      assert product.invalid?
      assert product.errors.added?(:lactosa, :inclusion, value: nil)
    end

    test "apto_vegano is invalid" do
      product = build(:v1_product, apto_vegano: nil)

      assert product.invalid?
      assert product.errors.added?(:apto_vegano, :inclusion, value: nil)
    end

    test "unidad_medida is required" do
      product = build(:v1_product, unidad_medida: nil)

      assert product.invalid?
      assert product.errors.added?(:unidad_medida, :blank)
    end

    test "cantidad_medida is required" do
      product = build(:v1_product, cantidad_medida: nil)

      assert product.invalid?
      assert product.errors.added?(:cantidad_medida, :blank)
    end

    test "disponible invalid when not a number" do
      value = "a"
      product = build(:v1_product, disponible: value)

      assert product.invalid?
      assert product.errors.added?(:disponible, :not_a_number, value: value)
    end

    test "disponible invalid when negative" do
      value = -1
      product = build(:v1_product, disponible: value)

      assert product.invalid?
      assert product.errors.added?(:disponible, :greater_than_or_equal_to, value: value, count: 0)
    end

    test "req_eq invalid when not a number" do
      value = "a"
      product = build(:v1_product, req_eq: value)

      assert product.invalid?
      assert product.errors.added?(:req_eq, :not_a_number, only_float: true, value: value)
    end

    test "req_eq invalid when negative" do
      value = -1.0
      product = build(:v1_product, req_eq: value)

      assert product.invalid?
      assert product.errors.added?(:req_eq, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "pvd invalid when not a number" do
      value = "a"
      product = build(:v1_product, pvd: value)

      assert product.invalid?
      assert product.errors.added?(:pvd, :not_a_number, only_float: true, value: value)
    end

    test "pvd invalid when negative" do
      value = -1.0
      product = build(:v1_product, pvd: value)

      assert product.invalid?
      assert product.errors.added?(:pvd, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "pvd_iva invalid when not a number" do
      value = "a"
      product = build(:v1_product, pvd_iva: value)

      assert product.invalid?
      assert product.errors.added?(:pvd_iva, :not_a_number, only_float: true, value: value)
    end

    test "pvd_iva invalid when negative" do
      value = -1.0
      product = build(:v1_product, pvd_iva: value)

      assert product.invalid?
      assert product.errors.added?(:pvd_iva, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "pvd_iva_rec invalid when not a number" do
      value = "a"
      product = build(:v1_product, pvd_iva_rec: value)

      assert product.invalid?
      assert product.errors.added?(:pvd_iva_rec, :not_a_number, only_float: true, value: value)
    end

    test "pvd_iva_rec invalid when negative" do
      value = -1.0
      product = build(:v1_product, pvd_iva_rec: value)

      assert product.invalid?
      assert product.errors.added?(:pvd_iva_rec, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "pvp invalid when not a number" do
      value = "a"
      product = build(:v1_product, pvp: value)

      assert product.invalid?
      assert product.errors.added?(:pvp, :not_a_number, only_float: true, value: value)
    end

    test "pvp invalid when negative" do
      value = -1.0
      product = build(:v1_product, pvp: value)

      assert product.invalid?
      assert product.errors.added?(:pvp, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "peso invalid when not a number" do
      value = "a"
      product = build(:v1_product, peso: value)

      assert product.invalid?
      assert product.errors.added?(:peso, :not_a_number, only_float: true, value: value)
    end

    test "peso invalid when negative" do
      value = -1.0
      product = build(:v1_product, peso: value)

      assert product.invalid?
      assert product.errors.added?(:peso, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "cantidad_medida invalid when not a number" do
      value = "a"
      product = build(:v1_product, cantidad_medida: value)

      assert product.invalid?
      assert product.errors.added?(:cantidad_medida, :not_a_number, only_float: true, value: value)
    end

    test "cantidad_medida invalid when negative" do
      value = -1.0
      product = build(:v1_product, cantidad_medida: value)

      assert product.invalid?
      assert product.errors.added?(:cantidad_medida, :greater_than_or_equal_to,
                                   only_float: true, value: value, count: 0.0)
    end

    test "#shopify_adapter" do
      product = build(:v1_product)

      assert_kind_of V1::Products::Shopify::Adapter, product.shopify_adapter
    end

    test "#find_or_initialize_external_product return persisted record" do
      product = create(:v1_product)
      create(:v1_product_external_resource, product: product)

      external_product = product.find_or_initialize_external_product

      assert external_product.persisted?
      assert external_product.external_id.present?
    end

    test "#find_or_initialize_external_product return new record" do
      product = create(:v1_product)

      external_product = product.find_or_initialize_external_product

      assert_not external_product.persisted?
      assert external_product.external_id.blank?
    end
  end
end
