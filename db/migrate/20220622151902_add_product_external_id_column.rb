class AddProductExternalIdColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :v1_products, :external_id, :integer
  end
end
