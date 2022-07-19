# frozen_string_literal: true

module WithAudit
  def with_audit(operation_id:, shop:, params: {})
    audit = Audit.create(
      operation_id: operation_id,
      shop_domain: shop.shopify_domain,
      raw_params: params.to_json,
      status: Audit::STATUS_STARTED,
      started_at: Time.current
    )
    response = yield
    value = response.value
    response.success? ? audit.succeeded_with_message!(value) : audit.failed_with_message!(value)

    response
  rescue StandardError => e
    error_message = "Unexpected exception: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    audit.failed_with_message!(error_message)

    Response.failure(error_message)
  end
end
