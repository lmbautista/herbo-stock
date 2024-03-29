# frozen_string_literal: true

WEBHOOK_NAMESPACE = "shopify/webhooks"

ShopifyApp.configure do |config|
  config.webhook_jobs_namespace = WEBHOOK_NAMESPACE
  config.webhooks = [
    { topic: "app/uninstalled", address: "#{WEBHOOK_NAMESPACE}/app_uninstalled" },
    { topic: "fulfillments/create", address: "#{WEBHOOK_NAMESPACE}/fulfillment_created" }
  ]
  config.application_name = "HerboStock"
  config.old_secret = ""
  config.scope = "write_products,write_customers,write_draft_orders,read_fulfillments," \
                 "write_fulfillments,read_orders,write_inventory"
  # Consult this page for more scope options:
  # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2022-04"
  config.shop_session_repository = "Shop"

  config.reauth_on_access_scope_changes = true

  config.api_key = ENV.fetch("SHOPIFY_API_KEY", "").presence
  config.secret = ENV.fetch("SHOPIFY_API_SECRET", "").presence

  if defined? Rails::Server
    unless config.api_key
      raise("Missing SHOPIFY_API_KEY. See https://github.com/Shopify/shopify_app#requirements")
    end
    unless config.secret
      raise("Missing SHOPIFY_API_SECRET. See https://github.com/Shopify/shopify_app#requirements")
    end
  end
end

Rails.application.config.after_initialize do
  if ShopifyApp.configuration.api_key.present? && ShopifyApp.configuration.secret.present?
    ShopifyAPI::Context.setup(
      api_key: ShopifyApp.configuration.api_key,
      api_secret_key: ShopifyApp.configuration.secret,
      api_version: ShopifyApp.configuration.api_version,
      host_name: URI(ENV.fetch("HOST", "")).host || "",
      scope: ShopifyApp.configuration.scope,
      is_private: !ENV.fetch("SHOPIFY_APP_PRIVATE_SHOP", "").empty?,
      is_embedded: ShopifyApp.configuration.embedded_app,
      session_storage: ShopifyApp::SessionRepository,
      logger: Rails.logger,
      private_shop: ENV.fetch("SHOPIFY_APP_PRIVATE_SHOP", nil),
      user_agent_prefix: "ShopifyApp/#{ShopifyApp::VERSION}"
    )

    ShopifyApp::WebhooksManager.add_registrations
  end
end
