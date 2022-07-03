# frozen_string_literal: true

require "test_helper"

class AuditsControllerTest < ActionDispatch::IntegrationTest
  test "success" do
    audit = create(:audit)

    with_shopify_session(audit.shop) do
      get audits_path, params: {}

      assert_response :ok
      assert_template :index
    end
  end
end
