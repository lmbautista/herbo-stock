# frozen_string_literal: true

class CatalogLoaderController < AuthenticatedController
  def create
    CatalogLoaderJob.perform_later(**create_params)

    head :ok
  end

  private

  def create_params
    params
      .require(:catalog_loader)
      .permit(product_ids: [])
      .to_h
      .merge(shop_domain: current_shopify_session.shop)
  end
end
