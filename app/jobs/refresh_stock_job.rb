# frozen_string_literal: true

class RefreshStockJob < ApplicationJob
  def perform(args)
    args.stringify_keys!
    shop_domain = args.fetch("shop_domain")
    skus = args.fetch("skus", [])

    Shopify::RefreshStock.new(shop_domain, skus).call
  end
end
