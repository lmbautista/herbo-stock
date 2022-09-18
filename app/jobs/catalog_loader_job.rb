# frozen_string_literal: true

class CatalogLoaderJob < ApplicationJob
  def perform(args)
    args.stringify_keys!
    @shop_domain = args.fetch("shop_domain")
    @product_ids = args.fetch("product_ids", [])
    @repeat = args.fetch("repeat", false)
    @repeat_at = args.fetch("repeat_at", nil)
    @process_id = args.fetch("process_id", nil)

    program_next_repetition_if_needed
      .and_then { schedule_repetition_if_needed }
      .and_then { load_catalog }
  end

  private

  attr_reader :shop_domain,
              :product_ids,
              :repeat,
              :repeat_at,
              :process_id,
              :scheduler

  def shop
    @shop ||= ::Shop.find_by(shopify_domain: shop_domain)
  end

  def repeat?
    repeat && CatalogLoaderScheduler.exists?(process_id: process_id)
  end

  def schedule_repetition_if_needed
    return Response.success("Nothing to repeat") unless repeat?

    args = {
      repeat: true,
      repeat_at: scheduler.next_scheduled_at,
      process_id: process_id,
      product_ids: product_ids,
      shop_domain: shop.shopify_domain
    }
    CatalogLoaderJob.set(wait_until: repeat_at).perform_later(args)

    Response.success("Repetition scheduled succesfully")
  end

  def program_next_repetition_if_needed
    return Response.success("Nothing to repeat") unless repeat?

    @scheduler = CatalogLoaderScheduler.find_by!(process_id: process_id)
    return Response.success("Next repetition programmed") if scheduler.repeat

    response_failure(scheduler)
  end

  def load_catalog
    Catalog::Loader.new(shop.id, product_ids).call
  end

  def response_failure(record)
    id_error_message = "#{record.class}##{record.id}:"
    error_message = [id_error_message, record.errors.full_messages.to_sentence].join(" ")

    Response.failure(error_message)
  end
end
