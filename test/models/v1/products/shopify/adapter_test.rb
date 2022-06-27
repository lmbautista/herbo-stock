# frozen_string_literal: true

require "test_helper"

module V1
  module Products
    module Shopify
      class AdapterTest < ActiveSupport::TestCase
        test "#handle" do
          expected_handle = "copos-de-avena-1000gr"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.handle
          assert_equal expected_handle, adapter.handle
        end

        test "#title" do
          expected_title = "Copos de avena 1000gr"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.title
          assert_equal expected_title, adapter.title
        end

        test "#body_html" do
          expected_body_html = "<h1>HTML text</h1>"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.body_html
          assert_equal expected_body_html, adapter.body_html
        end

        test "#vendor" do
          expected_vendor = "Granovita"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.vendor
          assert_equal expected_vendor, adapter.vendor
        end

        test "#standardized_product_type" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.standardized_product_type
        end

        test "#custom_product_type" do
          expected_custom_product_type = "Desayuno y entre horas"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.custom_product_type
          assert_equal expected_custom_product_type, adapter.custom_product_type
        end

        test "#tags" do
          expected_tags = "Avena"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.tags
          assert_equal expected_tags, adapter.tags
        end

        test "#published" do
          expected_published = "TRUE"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.published
          assert_equal expected_published, adapter.published
        end

        test "#option1_name" do
          expected_option1_name = "Title"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.option1_name
          assert_equal expected_option1_name, adapter.option1_name
        end

        test "#option1_value" do
          expected_option1_value = "Default Title"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.option1_value
          assert_equal expected_option1_value, adapter.option1_value
        end

        test "#option2_name" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.option2_name
        end

        test "#option2_value" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.option2_value
        end

        test "#option3_name" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.option3_name
        end

        test "#option3_value" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.option3_value
        end

        test "#variant_sku" do
          expected_variant_sku = "01003"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_sku
          assert_equal expected_variant_sku, adapter.variant_sku
        end

        test "#variant_ean" do
          expected_variant_ean = "8423266500305"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_ean
          assert_equal expected_variant_ean, adapter.variant_ean
        end

        test "#variant_grams" do
          expected_variant_grams = 1000.0
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_grams
          assert_equal expected_variant_grams, adapter.variant_grams
        end

        test "#variant_inventory_tracker" do
          expected_invetory_tracker = "shopify"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_equal expected_invetory_tracker, adapter.variant_inventory_tracker
        end

        test "#variant_inventory_qty" do
          expected_variant_inventory_qty = 36
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_inventory_qty
          assert_equal expected_variant_inventory_qty, adapter.variant_inventory_qty
        end

        test "#variant_inventory_policy" do
          expected_variant_inventory_policy = "deny"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_inventory_policy
          assert_equal expected_variant_inventory_policy, adapter.variant_inventory_policy
        end

        test "#variant_fulfillment_service" do
          expected_variant_fulfillment_service = "manual"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_fulfillment_service
          assert_equal expected_variant_fulfillment_service, adapter.variant_fulfillment_service
        end

        test "#variant_price" do
          expected_variant_price = 3.14
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_price
          assert_equal expected_variant_price, adapter.variant_price
        end

        test "#variant_compare_at_price" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.variant_compare_at_price
        end

        test "#variant_requires_shipping" do
          expected_variant_requires_shipping = "TRUE"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_requires_shipping
          assert_equal expected_variant_requires_shipping, adapter.variant_requires_shipping
        end

        test "#variant_taxable" do
          expected_variant_taxable = "TRUE"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_taxable
          assert_equal expected_variant_taxable, adapter.variant_taxable
        end

        test "#variant_barcode" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.variant_barcode
        end

        test "#image_src" do
          expected_image_src = "https://distribudiet.net/webstore/images/01003.jpg"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.image_src
          assert_equal expected_image_src, adapter.image_src
        end

        test "#image_position" do
          expected_image_position = 1
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.image_position
          assert_equal expected_image_position, adapter.image_position
        end

        test "#image_alt_text" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.image_alt_text
        end

        test "#gift_card" do
          expected_gift_card = "FALSE"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.gift_card
          assert_equal expected_gift_card, adapter.gift_card
        end

        test "#seo_title" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.seo_title
        end

        test "#seo_description" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.seo_description
        end

        test "#google_shopping_default_fallback" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.google_shopping_default_fallback
        end

        test "#variant_image" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.variant_image
        end

        test "#variant_weight_unit" do
          expected_variant_weight_unit = "g"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.variant_weight_unit
          assert_equal expected_variant_weight_unit, adapter.variant_weight_unit
        end

        test "#cost_per_item" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_nil adapter.cost_per_item
        end

        test "#status" do
          expected_status = "active"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert adapter.status
          assert_equal expected_status, adapter.status
        end

        test "#to_csv" do
          expected_payload = "a30906cdd4a829e0d705172663c766ac"
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)

          assert_equal expected_payload, Digest::MD5.hexdigest(adapter.to_csv.to_s)
        end

        test "#to_product" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)
          shopify_product = adapter.to_product

          assert_kind_of ::Shopify::Product, shopify_product
          assert_equal shopify_product.id, product.find_or_initialize_external_product.external_id
          assert_equal shopify_product.shop_id, product.shop_id
          assert_equal shopify_product.title, adapter.title
          assert_equal shopify_product.body_html, adapter.body_html
          assert_equal shopify_product.vendor, adapter.vendor
          assert_equal shopify_product.product_type, adapter.custom_product_type
          assert_equal shopify_product.handle, adapter.handle
          assert_equal shopify_product.status, adapter.status
          assert_equal shopify_product.tags, adapter.tags
          assert_equal shopify_product.variants.as_json, adapter.product_variants.as_json
        end

        test "#product_variants" do
          product = build(:v1_product, **product_attrs)
          adapter = Adapter.new(product)
          shopify_product_variants = adapter.product_variants
          shopify_product_variant = shopify_product_variants.first

          assert_kind_of Array, shopify_product_variants
          assert_kind_of ::Shopify::ProductVariant, shopify_product_variant
          assert_equal shopify_product_variant.price,
                       adapter.variant_price
          assert_equal shopify_product_variant.sku,
                       adapter.variant_sku
          assert_equal shopify_product_variant.barcode,
                       adapter.variant_ean
          assert_equal shopify_product_variant.weight,
                       adapter.variant_grams
          assert_equal shopify_product_variant.weight_unit,
                       adapter.variant_weight_unit
          assert_equal shopify_product_variant.taxable,
                       ActiveModel::Type::Boolean.new.cast(adapter.variant_taxable)
          assert_equal shopify_product_variant.fulfillment_service,
                       adapter.variant_fulfillment_service
          assert_equal shopify_product_variant.inventory_policy,
                       adapter.variant_inventory_policy
          assert_equal shopify_product_variant.inventory_management,
                       adapter.variant_inventory_tracker
          assert_equal shopify_product_variant.inventory_quantity,
                       adapter.variant_inventory_qty
          assert_equal shopify_product_variant.requires_shipping,
                       ActiveModel::Type::Boolean.new.cast(adapter.variant_requires_shipping)
        end

        private

        def product_attrs
          {
            id: 1003,
            sku: "01003",
            definicion: "'COPOS DE AVENA 1000GR'",
            ampliacion: "<h1>HTML text</h1>",
            disponible: 36,
            iva: 2,
            req_eq: 1.40,
            pvd: 2.20,
            pvd_iva: 2.42,
            pvd_iva_rec: 2.45,
            pvp: 3.14,
            peso: 1,
            ean: "8423266500305",
            hay_foto: true,
            imagen: "https://distribudiet.net/webstore/images/01003.jpg",
            fecha_imagen: "04/03/2020 0:00:00",
            cat: "ALIMENTACIÓN, GRANEL, Cereales legumbres y frutos secos, "\
                 "Desayuno y entre horas, Varios",
            marca: "GRANOVITA",
            frio: false,
            congelado: false,
            bio: false,
            apto_diabetico: false,
            gluten: true,
            huevo: false,
            lactosa: false,
            apto_vegano: true,
            unidad_medida: "kilo",
            cantidad_medida: 1
          }
        end
      end
    end
  end
end
