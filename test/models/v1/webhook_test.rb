# frozen_string_literal: true

require "test_helper"

module V1
  class WebhookTest < ActiveSupport::TestCase
    test "has status" do
      assert_includes Webhook.included_modules, HasStatus
    end

    test "topic is required" do
      webhook = build(:v1_webhook, topic: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:topic, :blank)
    end

    test "body is required" do
      webhook = build(:v1_webhook, body: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:body, :blank)
    end

    test "body invalid" do
      webhook = build(:v1_webhook, body: "whatever")
      exception_message = "859: unexpected token at 'whatever'"

      assert webhook.invalid?
      assert webhook.errors.added?(:body, :invalid, exception_message: exception_message)
    end

    test "status is required" do
      webhook = build(:v1_webhook, status: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:status, :blank)
    end

    test "retries is required" do
      webhook = build(:v1_webhook, retries: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:retries, :blank)
    end

    test "retries invalid if less than zero" do
      value = -1
      webhook = build(:v1_webhook, retries: value)

      assert webhook.invalid?
      assert webhook.errors.added?(:retries, :greater_than_or_equal_to, value: value, count: 0)
    end

    test "topic is whitelisted" do
      topic = "whatever"
      webhook = build(:v1_webhook, topic: topic)

      assert webhook.invalid?
      assert webhook.errors.added?(:topic, :inclusion, value: topic)
    end

    test "succeeded_at is required if status is succeeded" do
      webhook = build(:v1_webhook, :succeeded, succeeded_at: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:succeeded_at, :blank)
    end

    test "failed_at is required if status is failed" do
      webhook = build(:v1_webhook, :failed, failed_at: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:failed_at, :blank)
    end

    test "#failed_with_message!" do
      expected_error_message = "error_message"
      webhook = build(:v1_webhook, status: nil)

      webhook.failed_with_message!(expected_error_message)

      assert webhook.failed?
      assert_equal expected_error_message, webhook.reload.message
    end

    test "shopify_domain is required" do
      webhook = build(:v1_webhook, shop_domain: nil)

      assert webhook.invalid?
      assert webhook.errors.added?(:shop_domain, :blank)
    end
  end
end
