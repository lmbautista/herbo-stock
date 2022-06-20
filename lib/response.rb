# frozen_string_literal: true

class Response
  attr_reader :value

  def initialize(success:, value: nil)
    @success = success
    @value = value
  end

  def and_then
    return self if failure?

    yield(value)
  end

  def on_failure
    return self if success?

    yield(value)
    self
  end

  def self.success(value)
    new(success: true, value: value)
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
