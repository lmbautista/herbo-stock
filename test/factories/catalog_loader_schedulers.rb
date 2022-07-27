# frozen_string_literal: true

FactoryBot.define do
  factory :catalog_loader_scheduler do
    shop_id { create(:shop) }
    time_unit { CatalogLoaderScheduler::TIME_UNIT_MINUTES }
    time_amount { 1 }
  end
end
