# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "database_cleaner"
require "database_cleaner/active_record"
require "factory_bot_rails"
# Mocks
require "minitest/hooks"
require "minitest/mock"
require "webmock/minitest"
require "mocha/minitest"

DatabaseCleaner.strategy = :transaction

# Helpers
require "helpers/fulfillment_service_helper"

class ActiveSupport::TestCase
  include Minitest::Hooks
  # Setup FactoryBot
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  def before_all
    super
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def with_shopify_session(shop, &block)
    stubbed_session = ShopifyAPI::Auth::Session.new(shop: shop.shopify_domain)
    ShopifyAPI::Utils::SessionUtils.stub(:load_current_session, stubbed_session, &block)
  end

  def with_offline_shopify_session(shop)
    stubbed_session = ShopifyAPI::Auth::Session.new(shop: shop.shopify_domain)

    ShopifyAPI::Utils::SessionUtils.stub(:load_offline_session, stubbed_session) do
      yield(stubbed_session)
    end
  end
end
