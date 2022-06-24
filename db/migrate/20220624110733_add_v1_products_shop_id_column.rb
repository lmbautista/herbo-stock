class AddV1ProductsShopIdColumn < ActiveRecord::Migration[7.0]
  def change
    add_reference :v1_products, :shop, null: false, foreign_key: true
  end
end
