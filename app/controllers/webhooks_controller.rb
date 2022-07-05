# frozen_string_literal: true

class WebhooksController < AuthenticatedController
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def index
    @webhooks_configuration = ShopifyAPI::Webhook.all(limit: 10)
    @webhooks = V1::Webhook.where(shop_domain: current_shopify_session.shop)
      .order(id: :desc)
      .page(page).per(per_page)

    render action: "index", layout: false
  end

  def per_page
    params[:per_page].presence || DEFAULT_PER_PAGE
  end

  def page
    params[:page].presence || DEFAULT_PAGE
  end
end
