class RemoveNotNullToV1Products < ActiveRecord::Migration[7.0]
  def change
    change_column_null :v1_products, :ean, true
    change_column_null :v1_products, :marca, true
    change_column_null :v1_products, :unidad_medida, true
  end
end
