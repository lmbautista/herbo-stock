# frozen_string_literal: true

class Shop < ApplicationRecord
  include ShopifyApp::ShopSessionStorageWithScopes

  has_many :products, class_name: "V1::Product", dependent: :destroy
  has_one :catalog_loader_scheduler, dependent: :destroy

  def api_version
    ShopifyApp.configuration.api_version
  end
end
