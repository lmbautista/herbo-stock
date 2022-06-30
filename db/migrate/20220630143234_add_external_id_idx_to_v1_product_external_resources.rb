class AddExternalIdIdxToV1ProductExternalResources < ActiveRecord::Migration[7.0]
  def change
    add_index :v1_product_external_resources, :external_id
  end
end
