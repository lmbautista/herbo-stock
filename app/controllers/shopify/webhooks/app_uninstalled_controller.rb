# frozen_string_literal: true

module Shopify
  module Webhooks
    class AppUninstalledController < Webhooks::ApplicationController
      def create
        job_params = job_params_for(create_params.to_h, TOPICS[:app_uninstalled])
        Shopify::Webhooks::AppUninstalledJob.handle(**job_params)

        head :ok
      end

      def create_params
        params.permit(*permited_params).except(:action, :controller)
      end

      def permited_params # rubocop:disable Metrics/MethodLength
        %i(id
           name
           email
           domain
           province
           country
           address1
           zip
           city
           source
           phone
           latitude
           longitude
           primary_locale
           address2
           created_at
           updated_at
           country_code
           country_name
           currency
           customer_email
           timezone
           iana_timezone
           shop_owner
           money_format
           money_with_currency_format
           weight_unit
           province_code
           taxes_included
           auto_configure_tax_inclusivity
           tax_shipping
           county_taxes
           plan_display_name
           plan_name
           has_discounts
           has_gift_cards
           myshopify_domain
           google_apps_domain
           google_apps_login_enabled
           money_in_emails_format
           money_with_currency_in_emails_format
           eligible_for_payments
           requires_extra_payments_agreement
           password_enabled
           has_storefront
           eligible_for_card_reader_giveaway
           finances
           primary_location_id
           cookie_consent_level
           visitor_tracking_consent_preference
           checkout_api_supported
           multi_location_enabled
           setup_required
           pre_launch_enabled
           enabled_presentment_currencies
           app_uninstalled)
      end
    end
  end
end
