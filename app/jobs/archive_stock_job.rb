# frozen_string_literal: true

class ArchiveStockJob < ApplicationJob
  def perform(args)
    args.stringify_keys!
    shop_domain = args.fetch("shop_domain")

    Shopify::ArchiveStock.new(shop_domain).call
    ArchiveStockJob.set(wait: 1.hour).perform_later(**args)
  end
end
