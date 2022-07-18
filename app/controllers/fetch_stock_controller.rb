# frozen_string_literal: true

class FetchStockController < ApplicationController
  def show
    render json: products, status: :ok
  end

  private

  def create_params
    params.permit(:shop, :sku).to_h
  end

  def sku
    create_params[:sku]
  end

  def shop
    @shop ||= Shop.find_by(shopify_domain: create_params[:shop])
  end

  def products
    return {} if shop.blank?

    products = V1::Product.where(shop: shop)
    products = products.where(sku: sku) if sku.present?

    products.pluck(:sku, :disponible).to_h
  end
end
