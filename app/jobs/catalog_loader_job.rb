# frozen_string_literal: true

class CatalogLoaderJob < ApplicationJob
  def perform(args)
    args.stringify_keys!
    shop_domain = args.fetch("shop_domain")
    product_ids = args.fetch("product_ids", [])
    shop = ::Shop.find_by(shopify_domain: shop_domain)

    Catalog::Loader.new(LOCAL_PATH, shop.id, product_ids).call
  end

  # Temporal path that would be replaced by the provider dynamic URL
  LOCAL_PATH = "/Users/lmbautista/Desktop/Herbomadrid/catalog-raw.csv"
end
