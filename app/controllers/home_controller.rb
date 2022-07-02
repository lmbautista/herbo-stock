# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification

  def index
    @shop_origin = current_shopify_domain
    @host = params[:host]
    @webhooks_configuration = ShopifyAPI::Webhook.all(limit: 10, session: shop_session)
    @audits = Audit.order(id: :desc).limit(10)
    @webhooks = V1::Webhook.order(id: :desc).limit(10)
  end

  private

  def shop_session
    ShopifyAPI::Utils::SessionUtils.load_offline_session(shop: @shop_origin)
  end
end
