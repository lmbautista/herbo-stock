# frozen_string_literal: true

module HasStatus
  # Adds the chance to have the status behaviour usually used in the app, for example
  #
  # class Record < ApplicationRecord
  #   include HasStatus
  #
  #   has_status statuses: %i(pending started finished),
  #              attribute: :status
  #              allowed_transitions: {
  #                pending: %i(started),
  #                started: %i(finished),
  #              }.freeze
  # end
  #
  # By default uses the `status` record attribute, however, can be overriden.
  #
  # Under the hood it transformed the statuses array into a key => value style, avoiding
  # postional arguments, so it will work as a:
  #
  # enum status: { pending: "pending", started: "started", finished: "finished" }
  #
  # It checks the transitions in order to disallow unsuported ones.
  #
  extend ActiveSupport::Concern

  included do |klass|
    klass.class_attribute :has_status_allowed_transitions,
                          :has_status_attribute,
                          :has_status_statuses
  end

  class_methods do # rubocop:disable Metrics/BlockLength:
    def has_status(statuses:, allowed_transitions:, attribute: :status)
      self.has_status_allowed_transitions = allowed_transitions
      self.has_status_attribute = attribute
      self.has_status_statuses = statuses

      configure_has_status_enum
      configure_has_status_validations
      define_method_has_status_valid_status_transition
      define_method_has_status_status_transition_allowed
    end

    private

    def configure_has_status_enum
      send(:has_status_statuses)
        .reduce({}) { |acc, value| acc.merge!(value.to_sym => value.to_s) }
        .then { |statuses| enum send(:has_status_attribute) => statuses }
    end

    def configure_has_status_validations
      validates has_status_attribute, presence: true
      validate :has_status_status_transition_allowed?
    end

    def define_method_has_status_valid_status_transition
      define_method "has_status_valid_status_transition?" do |from_status, to_status|
        self.class.send(:has_status_allowed_transitions)
          .fetch(from_status.to_sym) { [] }
          .include?(to_status.to_sym)
      end
    end

    def define_method_has_status_status_transition_allowed
      attribute = has_status_attribute
      attribute_was = "#{attribute}_was"

      define_method "has_status_status_transition_allowed?" do
        return true unless will_save_change_to_attribute?(attribute)
        return true if send(attribute_was).nil?
        return true if has_status_valid_status_transition?(send(attribute_was), send(attribute))

        errors.add attribute, :transition_not_allowed,
                   message: "transition to #{send(attribute)} is not allowed"
      end
    end
  end
end
