# frozen_string_literal: true

class CatalogLoaderScheduler < ApplicationRecord
  belongs_to :shop

  TIME_UNITS = [
    TIME_UNIT_MINUTES = "minutes",
    TIME_UNIT_HOURS = "hours",
    TIME_UNIT_DAYS = "days"
  ].freeze

  DEFAULT_TIME_UNIT = TIME_UNIT_HOURS
  DEFAULT_TIME_AMOUNT = 8

  enum time_unit: { minutes: TIME_UNIT_MINUTES, hours: TIME_UNIT_HOURS, days: TIME_UNIT_DAYS }

  validates :next_scheduled_at, presence: true, if: :process_id?
  validates :process_id, presence: true, if: :next_scheduled_at?
  validates :time_unit, presence: true
  validates :time_amount,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def schedule(process_id)
    delay = time_amount.to_i.send(time_unit)
    self.next_scheduled_at = Time.current + delay
    self.process_id = process_id

    save
  end

  def repeat
    delay = time_amount.to_i.send(time_unit)
    self.next_scheduled_at = Time.current + delay

    save
  end
end
