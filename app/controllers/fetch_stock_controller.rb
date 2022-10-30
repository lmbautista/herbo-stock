# frozen_string_literal: true

class FetchStockController < ApplicationController
  def show
    response = Shopify::FetchStock.new(create_params).call
    RefreshStockJob.perform_later(shop_domain: create_params.fetch(:shop),
                                  skus: create_params.fetch(:sku, []))

    render json: response.value, status: :ok
  end

  private

  def create_params
    params.permit(:shop, :sku).to_h
  end
end
