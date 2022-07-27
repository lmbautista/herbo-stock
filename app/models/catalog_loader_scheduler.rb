# frozen_string_literal: true

class CatalogLoaderScheduler < ApplicationRecord
  belongs_to :shop

  TIME_UNITS = [
    TIME_UNIT_MINUTES = "minutes",
    TIME_UNIT_HOURS = "hours",
    TIME_UNIT_DAYS = "DAYS"
  ].freeze
  enum time_unit: { minutes: TIME_UNIT_MINUTES, hours: TIME_UNIT_HOURS, days: TIME_UNIT_DAYS }

  validates :time_unit, presence: true
  validates :time_amount,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
