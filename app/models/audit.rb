# frozen_string_literal: true

class Audit < ApplicationRecord
  include HasStatus

  STATUSES = [
    STATUS_STARTED = "started",
    STATUS_SUCCEEDED = "succeeded",
    STATUS_FAILED = "failed"
  ].freeze

  has_status attribute: :status,
             statuses: STATUSES.map(&:to_sym),
             allowed_transitions: {
               started: %i(started succeeded failed)
             }.freeze

  validates :operation_id, presence: true
  validates :shop_domain, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :raw_params, presence: true

  validates :started_at, presence: true
  validates :succeeded_at, presence: true, if: :succeeded?
  validates :failed_at, presence: true, if: :failed?

  # Workaround till we learn how to schedule tasks in Heroku
  # This ugly thing should be forbidden
  after_commit :clean_up_old_records, on: :create

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
    super
  end

  def succeeded_with_message!(message)
    self.message = message

    succeeded!
  end

  def failed!
    self.failed_at = Time.current
    super
  end

  def failed_with_message!(message)
    self.message = message

    failed!
  end

  private

  AUDITS_LIMIT = 1000
  private_constant :AUDITS_LIMIT

  def clean_up_old_records
    audits_total = Audit.count(:id)
    return if audits_total <= AUDITS_LIMIT

    Audit.order(created_at: :asc).limit(1).destroy_all
  end
end
