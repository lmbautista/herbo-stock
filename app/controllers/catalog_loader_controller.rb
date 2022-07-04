# frozen_string_literal: true

class CatalogLoaderController < AuthenticatedController
  def create
    job_params = create_params.merge(shop_domain: current_shopify_session.shop)
    CatalogLoaderJob.perform_later(**job_params)

    head :ok
  end

  private

  def create_params
    params
      .require(:catalog_loader)
      .permit(product_ids: [])
      .to_h
  end
end
