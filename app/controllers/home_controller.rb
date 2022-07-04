# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification

  def index
    @shop_origin = current_shopify_domain
    @host = params[:host]
  end

  private

  def shop_session
    ShopifyAPI::Utils::SessionUtils.load_offline_session(shop: @shop_origin)
  end
end
