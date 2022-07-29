# frozen_string_literal: true

class CatalogLoaderSchedulerController < AuthenticatedController
  def new
    @catalog_loader_scheduler = CatalogLoaderScheduler.find_by(shop: current_shop)

    render :new, format: :js
  end

  def create
    response = Catalog::ScheduledLoader.new(
      create_params[:time_unit],
      create_params[:time_amount],
      current_shopify_session.shop
    ).call

    render json: { message: response.value }, status: :ok
  end

  private

  def create_params
    params
      .require(:catalog_loader_scheduler)
      .permit(:time_unit, :time_amount)
      .to_h
  end

  def current_shop
    @current_shop ||= Shop.find_by(shopify_domain: current_shopify_domain)
  end
end
