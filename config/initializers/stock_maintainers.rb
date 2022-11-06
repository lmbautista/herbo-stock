# frozen_string_literal: true

module StockMaintainers
  module_function

  def load_catalog_loader_scheduler
    ::Shop.all.each_with_index do |shop, idx|
      scheduler = find_or_create_default_catalog_loader_scheduler(shop)
      next if scheduler.blank?

      process_id = SecureRandom.hex(12)
      next unless scheduler.schedule(process_id)

      CatalogLoaderJob.set(wait: (5 * idx).minutes).perform_later(
        repeat: true,
        repeat_at: scheduler.next_scheduled_at,
        process_id: process_id,
        shop_domain: shop.shopify_domain
      )
    end
  end

  def load_stock_archiver
    ::Shop.all.each_with_index do |shop, idx|
      ArchiveStockJob.set(wait: (5 * idx).minutes)
        .perform_later(shop_domain: shop.shopify_domain)
    end
  end

  def load_stock_refresher
    ::Shop.all.each_with_index do |shop, idx|
      RefreshStockJob.set(wait: (5 * idx).minutes)
        .perform_later(shop_domain: shop.shopify_domain)
    end
  end

  def find_or_create_default_catalog_loader_scheduler(shop)
    CatalogLoaderScheduler.find_by(shop: shop) ||
      CatalogLoaderScheduler.create(
        shop: shop,
        time_unit: CatalogLoaderScheduler::DEFAULT_TIME_UNIT,
        time_amount: CatalogLoaderScheduler::DEFAULT_TIME_AMOUNT
      )
  end

  class << self
    private :find_or_create_default_catalog_loader_scheduler
  end
end

if defined?(Rails::Server)
  Rails.application.config.after_initialize do
    StockMaintainers.load_catalog_loader_scheduler
    StockMaintainers.load_stock_archiver
    StockMaintainers.load_stock_refresher
  end
end
