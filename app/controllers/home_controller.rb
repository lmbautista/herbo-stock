# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification

  def index
    @shop_origin = current_shopify_domain
    @host = params[:host]
    @products = V1::Product.all.map { [[_1.id, _1.definicion].join(" - "), _1.id] }
  end

  private

  def shop_session
    ShopifyAPI::Utils::SessionUtils.load_offline_session(shop: @shop_origin)
  end
end
