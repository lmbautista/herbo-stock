class AddNotNullToProductExternalResources < ActiveRecord::Migration[7.0]
  def change
    change_column_null :v1_product_external_resources, :external_id, true
    change_column_null :v1_product_external_resources, :kind, true
  end
end
