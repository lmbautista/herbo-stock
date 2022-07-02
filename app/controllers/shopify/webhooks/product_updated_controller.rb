# frozen_string_literal: true

module Shopify
  module Webhooks
    class ProductUpdatedController < Webhooks::ApplicationController
      def create
        job_params = job_params_for(create_params.to_h, TOPICS[:product_updated])
        Shopify::Webhooks::ProductsUpdateJob.handle(**job_params)

        head :ok
      end

      def create_params
        params.require(:product_updated).permit(*permited_params).except(:action, :controller)
      end

      def permited_params # rubocop:disable Metrics/MethodLength
        [
          :admin_graphql_api_id,
          :body_html,
          :created_at,
          :handle,
          :id,
          :product_type,
          :published_at,
          :published_scope,
          :status,
          :tags,
          :template_suffix,
          :title,
          :updated_at,
          :vendor,
          { image: {},
            images: [*images_params],
            options: [*options_params],
            values: [],
            variant_ids: [],
            variants: [*variants_params] }
        ]
      end

      def images_params
        [
          :admin_graphql_api_id,
          :alt,
          :created_at,
          :height,
          :id,
          :position,
          :product_id,
          :src,
          :updated_at,
          :width,
          { variant_ids: [] }
        ]
      end

      def options_params
        [
          :id,
          :name,
          :position,
          :product_id,
          { values: [] }
        ]
      end

      def variants_params # rubocop:disable Metrics/MethodLength
        %i(
          admin_graphql_api_id
          barcode
          compare_at_price
          created_at
          fulfillment_service
          grams
          id
          image_id
          inventory_item_id
          inventory_management
          inventory_policy
          inventory_quantity
          old_inventory_quantity
          option1
          option2
          option3
          position
          price
          product_id
          requires_shipping
          sku
          taxable
          title
          updated_at
          weight
          weight_unit
        )
      end
    end
  end
end
