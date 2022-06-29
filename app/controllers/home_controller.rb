# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification

  def index
    @shop_origin = current_shopify_domain
    @host = params[:host]
    @webhooks = ShopifyAPI::Webhook.all(limit: 10, session: shop_session)
  end

  private

  def shop_session
    ShopifyAPI::Utils::SessionUtils.load_offline_session(shop: @shop_origin)
  end
end
