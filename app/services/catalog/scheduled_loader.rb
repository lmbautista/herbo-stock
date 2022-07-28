# frozen_string_literal: true

module Catalog
  class ScheduledLoader
    include WithAudit

    def initialize(time_unit, time_amount, shop_domain)
      @time_unit = time_unit
      @time_amount = time_amount
      @shop_domain = shop_domain
    end

    def call
      with_audit(operation_id: operation_id, params: params, shop: shop) do
        create_or_update_scheduler
          .and_then { schedule_catalog_loader_scheduler }
          .and_then { |process_id| perform_later_catalog_loader_job(process_id) }
          .and_then do
            message = "Catalog loaded scheduled at #{scheduler.next_scheduled_at}"
            Response.success(message)
          end
      end
    end

    private

    attr_reader :time_unit, :time_amount, :shop_domain, :scheduler

    def shop
      @shop ||= Shop.find_by(shopify_domain: shop_domain)
    end

    def params
      {
        time_unit: time_unit,
        time_amount: time_amount,
        shop_domain: shop_domain
      }
    end

    def operation_id
      "Schedule catalog load"
    end

    def create_or_update_scheduler
      @scheduler = CatalogLoaderScheduler.find_or_initialize_by(shop: shop)
      scheduler.time_unit = time_unit
      scheduler.time_amount = time_amount

      return Response.success(scheduler) if scheduler.save

      response_failure(scheduler)
    end

    def schedule_catalog_loader_scheduler
      process_id = SecureRandom.hex(12)
      return Response.success(process_id) if scheduler.schedule(process_id)

      response_failure(scheduler)
    end

    def perform_later_catalog_loader_job(process_id)
      CatalogLoaderJob.perform_later(
        repeat: true,
        repeat_at: scheduler.next_scheduled_at,
        process_id: process_id,
        shop_domain: shop_domain
      )

      Response.success(process_id)
    end

    def response_failure(record)
      id_error_message = "#{record.class}##{record.id}:"
      error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

      Response.failure(error_message)
    end
  end
end
