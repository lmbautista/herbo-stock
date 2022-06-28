# frozen_string_literal: true

FactoryBot.define do
  factory :v1_webhook, class: "V1::Webhook" do
    topic { "app/uninstalled" }
    shop { build(:shop) }
    body { { id: 1 } }
    status { V1::Webhook::STATUS_SUCCEEDED }
    succeeded_at { Time.current }
    retries { 1 }
  end
end
