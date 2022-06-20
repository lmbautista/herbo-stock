# frozen_string_literal: true

module WithAudit
  def with_audit(operation_id:, params: {})
    audit_params = {
      operation_id: operation_id,
      raw_params: params.to_json,
      status: Audit::STATUS_STARTED,
      started_at: Time.current
    }

    audit = Audit.create(**audit_params)
    response = yield
    response.success? ? audit.succeeded! : audit.failed_with_message!(response.value)

    response
  rescue StandardError => e
    error_message = "Unexpected exception: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    audit.failed_with_message!(error_message)

    Response.failure(error_message)
  end
end
