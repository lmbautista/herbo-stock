# frozen_string_literal: true

FactoryBot.define do
  factory :audit do
    operation_id { "Shops::Shopify::Catalog::Load" }
    raw_params { "{\"a\":1,\"b\":2}" }
    status { Audit::STATUS_STARTED }
    started_at { Time.current }
    succeeded_at { nil }
    failed_at { nil }
    message { nil }
  end

  trait :succeeded do
    succeeded_at { Time.current }
    status { Audit::STATUS_SUCCEEDED }
  end

  trait :failed do
    failed_at { Time.current }
    status { Audit::STATUS_FAILED }
  end
end
