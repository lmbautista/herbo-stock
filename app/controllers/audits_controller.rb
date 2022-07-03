# frozen_string_literal: true

class AuditsController < AuthenticatedController
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def index
    @audits = Audit.where(shop_domain: current_shopify_session.shop)
      .order(id: :asc)
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
