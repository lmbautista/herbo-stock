# frozen_string_literal: true

require "test_helper"

module V1
  module Products
    module Shopify
      class ConfigurationTest < ActiveSupport::TestCase
        test "build configuration successfully" do
          expected_payload = "d6934b3a5e927b100e60d1c8285b1719"
          configuration = Configuration.new

          assert configuration.title_rules.is_a?(Array)
          assert configuration.categories_rules.is_a?(Array)
          assert configuration.tags_rules.is_a?(Array)
          assert_equal expected_payload, Digest::MD5.hexdigest(configuration.to_json)
        end
      end
    end
  end
end
