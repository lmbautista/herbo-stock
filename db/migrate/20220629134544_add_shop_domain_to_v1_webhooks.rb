class AddShopDomainToV1Webhooks < ActiveRecord::Migration[7.0]
  def change
    add_column :v1_webhooks, :shop_domain, :string, null: false
    add_index :v1_webhooks, :shop_domain
  end
end
