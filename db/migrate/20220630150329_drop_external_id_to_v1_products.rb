class DropExternalIdToV1Products < ActiveRecord::Migration[7.0]
  def change
    remove_column :v1_products, :external_id
  end
end
