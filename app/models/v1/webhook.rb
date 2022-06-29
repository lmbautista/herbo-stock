# frozen_string_literal: true

module V1
  class Webhook < ApplicationRecord
    include HasStatus

    ALLOWED_TOPICS = ShopifyApp.configuration.webhooks.map { _1[:topic] }.freeze
    STATUSES = [
      STATUS_SUCCEEDED = "succeeded",
      STATUS_FAILED = "failed"
    ].freeze

    has_status attribute: :status,
               statuses: STATUSES.map(&:to_sym),
               allowed_transitions: {
                 succeeded: %i(succeeded),
                 failed: %i(failed succeeded)
               }.freeze

    validates :topic, presence: true, inclusion: { in: ALLOWED_TOPICS }
    validates :body, presence: true, json: true
    validates :status, presence: true
    validates :succeeded_at, presence: true, if: :succeeded?
    validates :failed_at, presence: true, if: :failed?
    validates :shop_domain, presence: true
    validates :retries,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    def shop
      @shop ||= Shop.find_by(shopify_domain: shop_domain)
    end

    def succeeded?
      attribute_in_database(:status) == STATUS_SUCCEEDED ||
        will_save_change_to_status?(to: STATUS_SUCCEEDED)
    end

    def failed?
      attribute_in_database(:status) == STATUS_FAILED ||
        will_save_change_to_status?(to: STATUS_FAILED)
    end

    def succeeded!
      self.succeeded_at = Time.current
      self.failed_at = nil
      super
    end

    def failed!
      self.failed_at = Time.current
      super
    end

    def failed_with_message!(message)
      self.message = message

      failed!
    end
  end
end
