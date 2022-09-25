class ChangeIntegerLimitForExternalId < ActiveRecord::Migration[7.0]
  def change
    change_column :v1_product_external_resources, :external_id, :integer, limit: 8
  end
end
