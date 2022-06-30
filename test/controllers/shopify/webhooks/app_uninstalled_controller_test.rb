# frozen_string_literal: true

require "test_helper"

module Shopify
  module Webhooks
    class AppUninstalledControllerTest < ActionDispatch::IntegrationTest
      test "enqueue job successfully" do
        shop = create(:shop)
        webhook_params = webhook_params_for(shop)
        job_params = {
          topic: "app/uninstalled",
          shop_domain: shop.shopify_domain,
          body: webhook_params
        }

        assert_enqueued_with job: Shopify::Webhooks::AppUninstalledJob,
                             args: [job_params],
                             queue: "default" do
          post shopify_webhooks_app_uninstalled_path(webhook_params)

          assert_response :ok
        end
      end

      private

      def webhook_params_for(shop)
        {
          "id" => "64975208694",
          "name" => "test-shopify",
          "email" => "lmiguelbautista@gmail.com",
          "domain" => shop.shopify_domain,
          "province" => "Madrid",
          "country" => "ES",
          "address1" => "Wadus world, 34123 Wonderland",
          "zip" => "34123",
          "city" => "Wonderland",
          "source" => "",
          "phone" => "",
          "latitude" => "",
          "longitude" => "",
          "primary_locale" => "en",
          "address2" => "",
          "created_at" => "2022-06-13T16:29:51+02:00",
          "updated_at" => "2022-06-27T15:33:13+02:00",
          "country_code" => "ES",
          "country_name" => "Spain",
          "currency" => "EUR",
          "customer_email" => "lmiguelbautista@gmail.com",
          "timezone" => "(GMT+01:00) Europe/Madrid",
          "iana_timezone" => "Europe/Madrid",
          "shop_owner" => "Luis Miguel Bautista Fraile",
          "money_format" => "€{{amount_with_comma_separator}}",
          "money_with_currency_format" => "€{{amount_with_comma_separator}} EUR",
          "weight_unit" => "kg",
          "province_code" => "M",
          "taxes_included" => "true",
          "auto_configure_tax_inclusivity" => "",
          "tax_shipping" => "",
          "county_taxes" => "true",
          "plan_display_name" => "Developer Preview",
          "plan_name" => "partner_test",
          "has_discounts" => "false",
          "has_gift_cards" => "false",
          "myshopify_domain" => shop.shopify_domain,
          "google_apps_domain" => "",
          "google_apps_login_enabled" => "",
          "money_in_emails_format" => "€{{amount_with_comma_separator}}",
          "money_with_currency_in_emails_format" => "€{{amount_with_comma_separator}} EUR",
          "eligible_for_payments" => "true",
          "requires_extra_payments_agreement" => "false",
          "password_enabled" => "[FILTERED]",
          "has_storefront" => "true",
          "eligible_for_card_reader_giveaway" => "false",
          "finances" => "true",
          "primary_location_id" => "69631901942",
          "cookie_consent_level" => "implicit",
          "visitor_tracking_consent_preference" => "allow_all",
          "checkout_api_supported" => "true",
          "multi_location_enabled" => "true",
          "setup_required" => "false",
          "pre_launch_enabled" => "false",
          "enabled_presentment_currencies" => ["EUR"],
          "app_uninstalled" => {
            "id" => "64975208694",
            "name" => "test-shopify",
            "email" => "lmiguelbautista@gmail.com",
            "domain" => shop.shopify_domain,
            "province" => "Madrid",
            "country" => "ES",
            "address1" => "Wadus world, 34123 Wonderland",
            "zip" => "34123",
            "city" => "Wonderland",
            "source" => "",
            "phone" => "",
            "latitude" => "",
            "longitude" => "",
            "primary_locale" => "en",
            "address2" => "",
            "created_at" => "2022-06-13T16:29:51+02:00",
            "updated_at" => "2022-06-27T15:33:13+02:00",
            "country_code" => "ES",
            "country_name" => "Spain",
            "currency" => "EUR",
            "customer_email" => "lmiguelbautista@gmail.com",
            "timezone" => "(GMT+01:00) Europe/Madrid",
            "iana_timezone" => "Europe/Madrid",
            "shop_owner" => "Luis Miguel Bautista Fraile",
            "money_format" => "€{{amount_with_comma_separator}}",
            "money_with_currency_format" => "€{{amount_with_comma_separator}} EUR",
            "weight_unit" => "kg",
            "province_code" => "M",
            "taxes_included" => "true",
            "auto_configure_tax_inclusivity" => "",
            "tax_shipping" => "",
            "county_taxes" => "true",
            "plan_display_name" => "Developer Preview",
            "plan_name" => "partner_test",
            "has_discounts" => "false",
            "has_gift_cards" => "false",
            "myshopify_domain" => shop.shopify_domain,
            "google_apps_domain" => "",
            "google_apps_login_enabled" => "",
            "money_in_emails_format" => "€{{amount_with_comma_separator}}",
            "money_with_currency_in_emails_format" => "€{{amount_with_comma_separator}} EUR",
            "eligible_for_payments" => "true",
            "requires_extra_payments_agreement" => "false",
            "password_enabled" => "[FILTERED]",
            "has_storefront" => "true",
            "eligible_for_card_reader_giveaway" => "false",
            "finances" => "true",
            "primary_location_id" => "69631901942",
            "cookie_consent_level" => "implicit",
            "visitor_tracking_consent_preference" => "allow_all",
            "checkout_api_supported" => "true",
            "multi_location_enabled" => "true",
            "setup_required" => "false",
            "pre_launch_enabled" => "false",
            "enabled_presentment_currencies" => ["EUR"]
          }
        }
      end
    end
  end
end
