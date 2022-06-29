class DropShopToV1Webhooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :v1_webhooks, :shop_id
  end
end
