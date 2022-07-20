# frozen_string_literal: true

class Response
  attr_reader :value, :resource

  def initialize(success:, value: nil, resource: nil)
    @success = success
    @value = value
    @resource = resource
  end

  def and_then
    return self if failure?

    yield(value, resource)
  end

  def on_failure
    return self if success?

    yield(value)
    self
  end

  def self.success(value, resource = nil)
    new(success: true, value: value, resource: resource)
  end

  def self.failure(value)
    new(success: false, value: value)
  end

  def success?
    @success == true
  end

  def failure?
    @success == false
  end
end
