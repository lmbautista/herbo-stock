# frozen_string_literal: true

module V1
  module Products
    module Shopify
      class Adapter
        def initialize(product)
          @product = product
        end

        def handle
          product.definicion.downcase
            .gsub(" ", "-").gsub(/[(|)]/, "").gsub(/^'/, "").gsub(/'$/, "")
        end

        def title
          normalize_title(product.definicion)
            .gsub(/^'/, "").gsub(/'$/, "").capitalize
        end

        def body_html
          product.ampliacion.gsub(/\r\n?/, "\n")
        end

        def vendor
          product.marca&.capitalize
        end

        def standardized_product_type
          nil
        end

        def custom_product_type
          normalize_category(product.cat || [])
        end

        def tags
          build_tags(product.definicion || "")
            .compact.reject(&:empty?).join(", ")
        end

        def published
          true.to_s.upcase
        end

        def option1_name
          "Title"
        end

        def option1_value
          "Default Title"
        end

        def option2_name
          nil
        end

        def option2_value
          nil
        end

        def option3_name
          nil
        end

        def option3_value
          nil
        end

        def variant_sku
          product.sku
        end

        def variant_grams
          product.peso * 1000.0
        end

        def variant_inventory_tracker
          "shopify"
        end

        def variant_inventory_qty
          product.disponible
        end

        def variant_inventory_policy
          "deny"
        end

        def variant_fulfillment_service
          ::Shopify::FulfillmentServices::Distribudiet::SERVICE_NAME.parameterize
        end

        def variant_ean
          product.ean
        end

        def variant_price
          product.pvp
        end

        def variant_compare_at_price
          nil
        end

        def variant_requires_shipping
          true.to_s.upcase
        end

        def variant_taxable
          true.to_s.upcase
        end

        def variant_barcode
          nil
        end

        def image_src
          product.imagen
        end

        def image_position
          1
        end

        def image_alt_text
          nil
        end

        def gift_card
          false.to_s.upcase
        end

        def seo_title
          nil
        end

        def seo_description
          nil
        end

        def google_shopping_default_fallback
          nil
        end

        def variant_image
          nil
        end

        def variant_weight_unit
          "g"
        end

        def variant_tax_code
          nil
        end

        def cost_per_item
        end

        def status
          return "active" if product.disponible.positive?
          return "archived" if product.disponible.zero?
        end

        def to_csv # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          {
            "Handle" => handle,
            "Title" => title,
            "Body (HTML)" => body_html,
            "Vendor" => vendor,
            "Standardized Product Type" => standardized_product_type,
            "Custom Product Type" => custom_product_type,
            "Tags" => tags,
            "Published" => published,
            "Option1 Name" => option1_name,
            "Option1 Value" => option1_value,
            "Option2 Name" => option2_name,
            "Option2 Value" => option2_value,
            "Option3 Name" => option3_name,
            "Option3 Value" => option3_value,
            "Variant SKU" => variant_sku,
            "Variant Grams" => variant_grams,
            "Variant Inventory Tracker" => variant_inventory_tracker,
            "Variant Inventory Qty" => variant_inventory_qty,
            "Variant Inventory Policy" => variant_inventory_policy,
            "Variant Fulfillment Service" => variant_fulfillment_service,
            "Variant Price" => variant_price,
            "Variant Compare At Price" => variant_compare_at_price,
            "Variant Requires Shipping" => variant_requires_shipping,
            "Variant Taxable" => variant_taxable,
            "Variant Barcode" => variant_barcode,
            "Image Src" => image_src,
            "Image Position" => image_position,
            "Image Alt Text" => image_alt_text,
            "Gift Card" => gift_card,
            "SEO Title" => seo_title,
            "SEO Description" => seo_description,
            "Google Shopping / Google Product Category" => google_shopping_default_fallback,
            "Google Shopping / Gender" => google_shopping_default_fallback,
            "Google Shopping / Age Group" => google_shopping_default_fallback,
            "Google Shopping / MPN" => google_shopping_default_fallback,
            "Google Shopping / AdWords Grouping" => google_shopping_default_fallback,
            "Google Shopping / AdWords Labels" => google_shopping_default_fallback,
            "Google Shopping / Condition" => google_shopping_default_fallback,
            "Google Shopping / Custom Product" => google_shopping_default_fallback,
            "Google Shopping / Custom Label 0" => google_shopping_default_fallback,
            "Google Shopping / Custom Label 1" => google_shopping_default_fallback,
            "Google Shopping / Custom Label 2" => google_shopping_default_fallback,
            "Google Shopping / Custom Label 3" => google_shopping_default_fallback,
            "Google Shopping / Custom Label 4" => google_shopping_default_fallback,
            "Variant Image" => variant_image,
            "Variant Weight Unit" => variant_weight_unit,
            "Variant Tax Code" => variant_tax_code,
            "Cost per item" => cost_per_item,
            "Status" => status
          }
        end

        def to_product
          attributes = {
            id: product.find_or_initialize_external_product.external_id,
            shop_id: product.shop_id,
            title: title,
            body_html: body_html,
            vendor: vendor,
            product_type: custom_product_type,
            handle: handle,
            status: status,
            tags: tags,
            variants: product_variants,
            images: product_images
          }

          ::Shopify::Product.new(attributes)
        end

        def product_variants
          attributes = {
            price: variant_price,
            sku: variant_sku,
            barcode: variant_ean,
            weight: variant_grams,
            weight_unit: variant_weight_unit,
            taxable: ActiveModel::Type::Boolean.new.cast(variant_taxable),
            fulfillment_service: variant_fulfillment_service,
            inventory_policy: variant_inventory_policy,
            inventory_quantity: variant_inventory_qty,
            inventory_management: variant_inventory_tracker,
            requires_shipping: ActiveModel::Type::Boolean.new.cast(variant_requires_shipping)
          }

          Array.wrap(::Shopify::ProductVariant.new(attributes))
        end

        def product_images
          attributes = {
            position: image_position,
            alt: image_alt_text,
            src: image_src
          }

          Array.wrap(::Shopify::ProductImage.new(attributes))
        end

        private

        attr_reader :product

        def configuration
          @configuration ||= Configuration.new
        end

        def normalize_title(title)
          return "" if title.nil?

          title.upcase!
          title.strip!

          configuration.title_rules.each do |rule|
            next unless rule[:regexp].match(title)

            title.gsub!(rule[:regexp], rule[:normalized_value])
          end

          title
            .gsub(/^'/, "").gsub(/'$/, "").gsub("  ", " ") # spaces and symbols
            .gsub(/((\s)?gr)/, "g").gsub(/((\s)?g)/, "g") # units
            .capitalize
        end

        def normalize_category(category)
          return "" if category.empty?

          category.upcase!
          rule = configuration.categories_rules.find { _1[:regexp].match(category) }

          (rule.nil? ? category : rule[:normalized_value]).downcase.capitalize
        end

        def build_tags(title)
          return [] if title.empty?

          title.upcase!
          title.strip!
          configuration.tags_rules.map do |rule|
            rule_match = rule[:regexp].match(title)
            (rule_match ? rule[:normalized_value]&.gsub(" y ", "&") : "")&.downcase&.capitalize
          end
        end
      end
    end
  end
end
