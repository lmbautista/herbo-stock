# frozen_string_literal: true

class AuditsController < AuthenticatedController
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def index
    @audits = Audit
      .where(search_params)
      .order(id: :desc)
      .page(page).per(per_page)

    render action: "index", layout: false
  end

  def per_page
    pagination_params.fetch(:per_page, DEFAULT_PER_PAGE)
  end

  def page
    pagination_params.fetch(:page, DEFAULT_PAGE)
  end

  def search_params
    params.permit(:status).to_h
      .merge(shop_domain: current_shopify_session.shop)
      .compact
  end

  def pagination_params
    params.permit(:per_page, :page).to_h
  end
end
