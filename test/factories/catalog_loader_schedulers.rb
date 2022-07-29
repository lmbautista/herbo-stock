# frozen_string_literal: true

FactoryBot.define do
  factory :catalog_loader_scheduler do
    shop { create(:shop) }
    time_unit { CatalogLoaderScheduler::TIME_UNIT_MINUTES }
    time_amount { 1 }

    trait :scheduled do
      next_scheduled_at { Time.current }
      process_id { SecureRandom.hex(12) }
    end
  end
end
