# frozen_string_literal: true

module FulfillmentServiceHelper
  def with_mocked_fulfillment_service(shop)
    with_offline_shopify_session(shop) do |session|
      fulfillment_services = [build_fulfillment_service(session, fulfillment_service_params)]
      mock_get_fulfillment_services(fulfillment_services)

      yield
    end
  end

  def fulfillment_service_params
    {
      "admin_graphql_api_id" => "gid://shopify/ApiFulfillmentService/61749559542",
      "callback_url" => ENV.fetch("HOST", nil),
      "fulfillment_orders_opt_in" => false,
      "handle" => "distribudiet-fulfillment",
      "id" => 61_749_559_542,
      "inventory_management" => true,
      "location_id" => 70_191_939_830,
      "name" => "Distribudiet Fulfillment",
      "provider_id" => nil,
      "tracking_support" => false,
      "email" => nil,
      "service_name" => "Distribudiet Fulfillment",
      "include_pending_stock" => false
    }
  end

  def build_fulfillment_service(session, params)
    fulfillment_service = ::ShopifyAPI::FulfillmentService.new(session: session)
    fulfillment_service.original_state = params
    params.each { |key, value| fulfillment_service.send("#{key}=", value) }

    fulfillment_service
  end

  def mock_get_fulfillment_services(fulfillment_services, times = 1)
    ::ShopifyAPI::FulfillmentService
      .expects(:all)
      .times(times)
      .returns(fulfillment_services)
  end
end
