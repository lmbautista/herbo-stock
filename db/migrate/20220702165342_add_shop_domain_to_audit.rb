class AddShopDomainToAudit < ActiveRecord::Migration[7.0]
  def change
    add_column :audits, :shop_domain, :string, null: false
    add_index :audits, :shop_domain
  end
end
